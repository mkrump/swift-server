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

}
