import Foundation
import XCTest
@testable import HTTPRequest

class RangeRequestTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFullySpecifiedRange() {
        let fullySpecifiedRange = "bytes=0-1023"
        let range = parseRange(byteRange: fullySpecifiedRange, fileSize: 1024)
        XCTAssertEqual(1024, range!.upperBound)
        XCTAssertEqual(0, range!.lowerBound)
    }

    func testNoUpperBound() {
        let fullySpecifiedRange = "bytes=10-"
        let range = parseRange(byteRange: fullySpecifiedRange, fileSize: 1024)
        XCTAssertEqual(1024, range!.upperBound)
        XCTAssertEqual(10, range!.lowerBound)
    }

    func testNoLowerBound() {
        let fullySpecifiedRange = "bytes=-500"
        let range = parseRange(byteRange: fullySpecifiedRange, fileSize: 1024)
        XCTAssertEqual(1024, range!.upperBound)
        XCTAssertEqual(1024 - 500, range!.lowerBound)
    }

    func testExceedsUpperBound() {
        let fullySpecifiedRange = "bytes=0-1000"
        let range = parseRange(byteRange: fullySpecifiedRange, fileSize: 256)
        XCTAssertEqual(256, range!.upperBound)
        XCTAssertEqual(0, range!.lowerBound)
    }

    func testBadRange() {
        let fullySpecifiedRange = "bytes=-"
        let range = parseRange(byteRange: fullySpecifiedRange, fileSize: 256)
        XCTAssertNil(range)
    }
}
