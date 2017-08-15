import XCTest

class PartialContentTests: XCTestCase {
    var bytes: [UInt8]!

    override func setUp() {
        bytes = [24, 163, 209, 194, 255, 1, 184, 230, 37, 208, 140]
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDataPartialRead() {
        let data = Data(bytes: bytes)
        let range = Range(4..<8)
        var subData: [UInt8] = []
        subData = Array(data.subdata(in: range))
        XCTAssertEqual(subData, [255, 1, 184, 230])
    }

    func testDataPartialReadNoEnd() {
        let data = Data(bytes: bytes)
        let range = Range(0..<data.count)
        var subData: [UInt8] = []
        subData = Array(data.subdata(in: range))
        XCTAssertEqual(subData, bytes)
    }
}
