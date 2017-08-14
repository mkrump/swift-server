import XCTest
@testable import HTTPResponse

class HTTPResponseTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testsetVersion() {
        var httpResponse = HTTPResponse()
        httpResponse = httpResponse.setVersion(version: 1.1)
        XCTAssertEqual(httpResponse.version, "HTTP/1.1")
    }

    func testemptyVersion() {
        var httpResponse = HTTPResponse()
        httpResponse = httpResponse.setVersion(version: 1000.0)
        XCTAssertEqual(httpResponse.version, "HTTP/0.9")
    }

    func testResponse() {
        var httpResponse = HTTPResponse()
        httpResponse = httpResponse.setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
                .setMessage(message: Data("HI".utf8))
        let expectedResponse = "HTTP/1.1 200 OK\r\n\r\nHI"
        if let actual = String(data: httpResponse.generateResponse(), encoding: .utf8) {
            XCTAssertEqual(actual, expectedResponse)
        }
    }

    func testHeaders() {
        var httpResponse = HTTPResponse()
        httpResponse = httpResponse.setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
                .addHeader(key: "Allow", value: "OPTIONS, GET, HEAD, POST")
        let expectedResponse = "HTTP/1.1 200 OK\r\n" +
                "Allow: OPTIONS, GET, HEAD, POST\r\n\r\n"
        if let actual = String(data: httpResponse.generateResponse(), encoding: .utf8) {
            XCTAssertEqual(actual, expectedResponse)
        }
    }
}
