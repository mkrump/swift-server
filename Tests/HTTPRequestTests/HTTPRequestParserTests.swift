import XCTest
import Socket
@testable import HTTPRequest

class HTTPRequestParserTests: XCTestCase {
    var testRequestLine: String!
    var testHeaders: String!
    var testMessageBody: String!
    var testMessage: String!
    var testHeaderAndRequestLine: String!

    override func setUp() {
        super.setUp()
        testRequestLine = "POST /form HTTP/1.1"
        testHeaders = "Content-Length: 11\r\nHost: localhost:5000\r\n" +
                "Connection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n" +
                "Accept-Encoding: gzip,deflate"
        testMessageBody = "My\"=\"Data\""
        testHeaderAndRequestLine = testRequestLine + "\r\n" +
                testHeaders
        testMessage = testHeaderAndRequestLine + "\r\n\r\n" + testMessageBody
    }

    override func tearDown() {
        super.tearDown()
    }

    func testParseHTTPRequest() {
        let requestAndBody = try? parseHTTPRequest(request: testMessage)
        XCTAssertEqual(requestAndBody!.messageBody, testMessageBody)
        XCTAssertEqual(requestAndBody!.headerAndRequestLine, testHeaderAndRequestLine)
    }

    func testParseRequestLine() {
        let requestLine = try? parseRequestLine(requestLine: testRequestLine)
        XCTAssertEqual(requestLine!.target, "/form")
        XCTAssertEqual(requestLine!.httpMethod, "POST")
        XCTAssertEqual(requestLine!.httpVersion, "HTTP/1.1")
    }

    func testHeaderParser() {
        let headersDict = parseHeaders(headers: testHeaders)
        XCTAssertEqual(headersDict!, ["Content-Length": "11",
                                      "Host": "localhost:5000",
                                      "Connection": "Keep-Alive",
                                      "User-Agent": "Apache-HttpClient/4.3.5 (java 1.5)",
                                      "Accept-Encoding": "gzip,deflate"])

    }

    func testBadRequest() {
        XCTAssertThrowsError(try parseRequestLine(requestLine: "BAD REQUEST!!!"))
    }

    func testBadStartLine() {
        XCTAssertThrowsError(try parseRequestLine(requestLine: "POST /route"))
    }
}
