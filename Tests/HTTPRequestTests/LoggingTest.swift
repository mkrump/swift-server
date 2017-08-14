import Foundation
import SimpleURL
import XCTest
@testable import FileSystem

class LoggingTests: XCTestCase {
    func testFileWrite() {
        let url = simpleURL(path: "./", baseName: "testlog.log")
        let contents = "HI!"
        guard let logger = try? Logger(url: url) else {
            XCTFail()
            return
        }
        logger.appendLog(contents: contents)
        if let logContents = logger.readLog() {
            XCTAssertEqual(logContents, "HI!\n")
        } else {
            XCTFail()
        }
    }

    func testMultipleFileWrites() {
        let url = simpleURL(path: "./", baseName: "testlog.log")
        let contents = "HI!"
        guard let logger = try? Logger(url: url) else {
            XCTFail()
            return
        }
        logger.appendLog(contents: contents)
        logger.appendLog(contents: contents)
        if let logContents = logger.readLog() {
            XCTAssertEqual(logContents, "HI!\nHI!\n")
        } else {
            XCTFail()
        }
    }
}
