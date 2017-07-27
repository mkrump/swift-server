import XCTest
import Socket
@testable import Templates

class HTTPResponseTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDirectoryListing() {
        let listDirHTML = dirListing(target: "/", directories: ["dir1", "dir2"])
        if !(listDirHTML.contains("<a href=/dir1>dir1</a>") && listDirHTML.contains("<a href=/dir2>dir2</a>")) {
            XCTFail()
        }
    }
}
