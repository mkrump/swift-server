import XCTest
@testable import HTTPResponse

func dateHelper(year: Int, month: Int, day: Int, hour: Int? = 0, minute: Int? = 0, second: Int? = 0) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.hour = hour
    dateComponents.minute = minute
    dateComponents.second = second
    dateComponents.calendar = Calendar.current
    return dateComponents.date
}

class DateHeaderTests: XCTestCase {
    override func setUp() {
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testDate1() {
        let date = dateHelper(year: 2017, month: 08, day: 04, hour: 12, minute: 31, second: 10)
        XCTAssertEqual("Fri, 04 Aug 2017 17:31:10 GMT", date!.dateToRFC822String())
    }

    func testDate2() {
        let date = dateHelper(year: 2016, month: 12, day: 31, hour: 12, minute: 00, second: 00)
        XCTAssertEqual("Sat, 31 Dec 2016 18:00:00 GMT", date!.dateToRFC822String())
    }
}
