import Foundation
import XCTest
import CryptoSwift

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

class SHA1Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHash() {
        let bytes = Array("default content".utf8)
        let hash = bytes.sha1()
        XCTAssertEqual("dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec", hash.toHexString())
    }
}
