import XCTest
import Socket
@testable import HTTPRequest

class HTTPRequestParserTests: XCTestCase {
    var testRequestLine: String!
    var testHeaders: String!
    var testMessageBody: String!
    var testMessage: String!

    override func setUp() {
        super.setUp()
        testRequestLine = "POST /form HTTP/1.1"
        testHeaders = "Content-Length: 11\r\nHost: localhost:5000\r\n" +
                "Connection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n" +
                "Accept-Encoding: gzip,deflate"
        testMessageBody = "My\"=\"Data\""
        testMessage = testRequestLine + "\r\n" +
                testHeaders + "\r\n\r\n" +
                testMessageBody
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHTTPParserTopLevelParse() {
        if let httpRequestParser = try? HTTPParsedRequest(request: testMessage),
           let requestLine = httpRequestParser.requestLine,
           let headers = httpRequestParser.headers,
           let headersDict = httpRequestParser.headers!.headerDict,
           let messageBody = httpRequestParser.messageBody {
            XCTAssertNotNil(requestLine)
            XCTAssertEqual(headers.rawHeaders, testHeaders)
            XCTAssertEqual(messageBody, testMessageBody)
            XCTAssertEqual(headersDict, ["Content-Length": "11",
                                         "Host": "localhost:5000",
                                         "Connection": "Keep-Alive",
                                         "User-Agent": "Apache-HttpClient/4.3.5 (java 1.5)",
                                         "Accept-Encoding": "gzip,deflate"])
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
        XCTAssertEqual(headers.rawHeaders, testHeaders)
    }

    func testBadRequest() {
        XCTAssertThrowsError(try HTTPParsedRequest(request: "BAD REQUEST!!!"))
    }

    func testBadStartLine() {
        XCTAssertThrowsError(try HTTPParsedRequest(request: "POST /route"))
    }
}
