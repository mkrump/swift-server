import XCTest
import SimpleURL
@testable import Templates

class HTTPResponseTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDirectoryListing() {
        let url = simpleURL(path: "/", baseName: "/otherDir")
        let listDirHTML = dirListing(url: url, directories: ["dir1", "dir2"])
        if !(listDirHTML.contains("<a href=/otherDir/dir1>dir1</a>") &&
             listDirHTML.contains("<a href=/otherDir/dir2>dir2</a>")) {
            XCTFail()
        }
    }
}
