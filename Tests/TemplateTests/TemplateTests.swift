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

    func testBasic() {
        let basicHTML = basicTemplate(message: "Hello!")
        XCTAssertTrue(basicHTML.contains("<p>Hello!</p>"))
    }

    func testEchoParams() {
        let echoHTML = echoParams(params: ["a": "1", "b": "2"])
        if !(echoHTML.contains("<li>a = 1</li>")
                && echoHTML.contains("<li>b = 2</li>")) {
            XCTFail()
        }
    }

    func testForm() {
        let formHTML = generateForm(target: "/form", data: Data("Hello!".utf8))
        if !(formHTML.contains("action=\"form\"")
                && formHTML.contains("<p>Current values: Hello!</p>")) {
            XCTFail()
        }
    }
}
