import XCTest
import Socket
@testable import HTTPRequest

class HTTPHeaderTests: XCTestCase {
    var testRequestLine: String!
    var testHeaders: String!
    var testMessageBody: String!
    var testMessage: String!

    override func setUp() {
        super.setUp()
        testHeaders = "Content-Length: 11\r\nHost: localhost:5000\r\n" +
        "Connection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n" +
        "Accept-Encoding: gzip,deflate"
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHeaderParse() {
        let parsedHeaders = parseHeaders(headers: testHeaders)
        if let headerDict = parsedHeaders {
            XCTAssertEqual(headerDict, ["Content-Length": "11",
                                        "Host": "localhost:5000", "Connection":
                                        "Keep-Alive", "User-Agent": "Apache-HttpClient/4.3.5 (java 1.5)",
                                        "Accept-Encoding": "gzip,deflate"])
        }
    }
}
