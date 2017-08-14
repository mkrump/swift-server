import Foundation
import SimpleURL

public class Logger {
    public private(set) var url: simpleURL

    public init(url: simpleURL) throws {
        self.url = url
        try createLogFile()
    }

    public func createLogFile() throws {
        try "".write(toFile: url.fullName, atomically: true, encoding: String.Encoding.utf8)
    }

    public func appendLog(contents: String) {
        if let fileHandle = FileHandle(forWritingAtPath: url.fullName) {
            _ = fileHandle.seekToEndOfFile()
            fileHandle.write(Data((contents + "\n").utf8))
            fileHandle.closeFile()
        }
    }

    public func readLog() -> String? {
        return try? String(contentsOfFile: url.fullName)
    }
}