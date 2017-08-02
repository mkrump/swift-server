import Foundation
import XCTest
import MocksTests
@testable import HTTPRequest

class EtagTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHash1() {
        XCTAssertEqual("dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec",
                generateEtag(content: Data("default content".utf8)))
    }

    func testHash2() {
        XCTAssertEqual("5c36acad75b78b82be6d9cbbd6143ab7e0cc04b0",
                generateEtag(content: Data("patched content".utf8)))
    }

    func testReasourceEtagIsMatch() {
        let currentEtag = "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"
        let mockHeaders = MockHeaders(rawHeaders: "If-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\n",
                headerDict: ["If-Match": "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"])
        XCTAssertTrue(eTagValid(currentEtag: currentEtag, headers: mockHeaders))
    }

    func testReasourceEtagNotMatch() {
        let currentEtag = "no match"
        let mockHeaders = MockHeaders(rawHeaders: "If-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\n",
                headerDict: ["If-Match": "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"])
        XCTAssertFalse(eTagValid(currentEtag: currentEtag, headers: mockHeaders))
    }

    func testNoCurrentEtagReturnsTrue() {
        let mockHeaders = MockHeaders(rawHeaders: "If-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\n",
                headerDict: ["If-Match": "dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec"])
        XCTAssertTrue(eTagValid(currentEtag: nil, headers: mockHeaders))
    }
}
