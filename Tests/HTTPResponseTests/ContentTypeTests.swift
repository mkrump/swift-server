import XCTest
@testable import HTTPResponse

class ContentTypeTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testJPEGContentType() {
        let jpegFile = "/image.jpeg"
        let contentType = inferContentType(fileName: jpegFile)
        XCTAssertEqual("image/jpeg", contentType)
    }

    func testUnkownContentTypeIsText() {
        let textFile = "/text-file.weirdfiletype"
        let contentType = inferContentType(fileName: textFile)
        XCTAssertEqual("text/html", contentType)
    }

    func testPNGContentType() {
        let pngFile = "/image.png"
        let contentType = inferContentType(fileName: pngFile)
        XCTAssertEqual("image/png", contentType)
    }
}
