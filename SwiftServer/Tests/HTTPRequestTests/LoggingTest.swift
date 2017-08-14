import Foundation
import XCTest
@testable import FileSystem

class LoggingTests: XCTestCase {
    func testFileWrite() {
        let path = "testlog.log"
        let contents = "HI!"
        guard let logger = try? Logger(path: path) else {
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
        let path = "testlog.log"
        let contents = "HI!"
        guard let logger = try? Logger(path: path) else {
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
