import XCTest
import Socket
@testable import HTTPRequest

class HTTPRequestParserTests: XCTestCase {
    var testStartLine: String!
    var testHeaders: String!
    var testMessageBody: String!
    var testMessage: String!

    override func setUp() {
        super.setUp()
        testStartLine = "POST /form HTTP/1.1"
        testHeaders = "Content-Length: 11\r\nHost: localhost:5000\r\n" +
                "Connection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n" +
                "Accept-Encoding: gzip,deflate"
        testMessageBody = "My\"=\"Data\""
        testMessage = testStartLine + "\r\n" +
                testHeaders + "\r\n\r\n" +
                testMessageBody
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHTTPParserTopLevelParse() {
        if let httpRequestParser = try? HTTPParsedRequest(request: testMessage),
           let startLine = httpRequestParser.startLine,
           let headers = httpRequestParser.headers,
           let messageBody = httpRequestParser.messageBody {
            XCTAssertNotNil(startLine)
            XCTAssertEqual(headers, testHeaders)
            XCTAssertEqual(messageBody, testMessageBody)
        } else {
            XCTFail()
            return
        }
    }

    func testHTTPParserHeaderParse() {
        guard let httpRequestParser = try? HTTPParsedRequest(request: testMessage),
              let headers = httpRequestParser.headers else {
            XCTFail()
            return
        }
        XCTAssertEqual(headers, testHeaders)
    }

    func testBadRequest() {
        XCTAssertThrowsError(try HTTPParsedRequest(request: "BAD REQUEST!!!"))
    }

    func testBadStartLine() {
        XCTAssertThrowsError(try HTTPParsedRequest(request: "POST /route"))
    }

    func testStartLineParse() {
        guard let startLine = try? RequestLine(requestLine: testStartLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(startLine.target, "/form")
        XCTAssertEqual(startLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(startLine.httpMethod, "POST")
    }

    func testStartLineURLEncodedTarget() {
        testStartLine = "GET /search?query=weird+characters%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D HTTP/1.1"
        guard let startLine = try? RequestLine(requestLine: testStartLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(startLine.target, "/search")
        print(startLine.params!)
        XCTAssertEqual(startLine.params!["query"], "weird+characters!#$&\'()*+,/:;=?@[]")
        XCTAssertEqual(startLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(startLine.httpMethod, "GET")
    }

    func testStartLineQueryParams() {
        testStartLine = "GET /search?variable_1=Hello&variable_2=World HTTP/1.1"
        guard let startLine = try? RequestLine(requestLine: testStartLine) else {
            XCTFail()
            return
        }
        XCTAssertEqual(startLine.target, "/search")
        XCTAssertEqual(startLine.params!["variable_1"], "Hello")
        XCTAssertEqual(startLine.params!["variable_2"], "World")
        XCTAssertEqual(startLine.httpVersion, "HTTP/1.1")
        XCTAssertEqual(startLine.httpMethod, "GET")
    }

}
