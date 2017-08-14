import XCTest
import Socket
@testable import HTTPRequest

class HTTPRequestLineTests: XCTestCase {
    var testRequestLine: String!
    var testHeaders: String!
    var testMessageBody: String!
    var testMessage: String!

    override func setUp() {
        super.setUp()
        testRequestLine = "POST /form HTTP/1.1"
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStartLineParse() {
        guard let requestLine = try? RequestLine(requestLine: testRequestLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(requestLine.target, "/form")
        XCTAssertEqual(requestLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(requestLine.httpMethod, "POST")
    }

    func testStartLineURLEncodedTarget() {
        testRequestLine = "GET /search?query=weird+characters%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D HTTP/1.1"
        guard let requestLine = try? RequestLine(requestLine: testRequestLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(requestLine.target, "/search")
        XCTAssertEqual(requestLine.params!["query"], "weird+characters!#$&\'()*+,/:;=?@[]")
        XCTAssertEqual(requestLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(requestLine.httpMethod, "GET")
    }

    func testStartLineQueryParams() {
        testRequestLine = "GET /search?variable_1=Hello&variable_2=World HTTP/1.1"
        guard let requestLine = try? RequestLine(requestLine: testRequestLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(requestLine.target, "/search")
        XCTAssertEqual(requestLine.params!["variable_1"], "Hello")
        XCTAssertEqual(requestLine.params!["variable_2"], "World")
        XCTAssertEqual(requestLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(requestLine.httpMethod, "GET")
    }
}
