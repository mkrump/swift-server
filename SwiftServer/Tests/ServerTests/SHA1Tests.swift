import Foundation
import XCTest
import MocksTests
import HTTPRequest
import CryptoSwift

func eTagIsMatch(currentEtag: String, headers: HeaderParse) -> Bool? {
    if let headerDict = headers.headerDict,
       let newEtag = headerDict["If-Match"] {
        return currentEtag == newEtag
    }
    return nil
}

func UpdateEtag(newContent: Data) {
    let hash = newContent.sha1()
}

class SHA1Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHash1() {
        let bytes = Data("default content".utf8)
        let hash = bytes.sha1()
        XCTAssertEqual("dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec", hash.toHexString())
    }

    func testHash2() {
        let bytes = Array("patched content".utf8)
        let hash = bytes.sha1()
        XCTAssertEqual("5c36acad75b78b82be6d9cbbd6143ab7e0cc04b0", hash.toHexString())
    }

    func testReasourceEtagIsMatch() {
        let currentEtag = "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"
        let mockHeaders = MockHeaders(rawHeaders: "If-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\n",
                headerDict: ["If-Match": "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"])
        XCTAssertTrue(eTagIsMatch(currentEtag: currentEtag, headers: mockHeaders)!)
    }

    func testReasourceEtagNotMatch() {
        let currentEtag = "no match"
        let mockHeaders = MockHeaders(rawHeaders: "If-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\n",
                headerDict: ["If-Match": "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"])
        XCTAssertFalse(eTagIsMatch(currentEtag: currentEtag, headers: mockHeaders)!)
    }
}
