import Foundation

public class Logger {
    public private(set) var path: String

    public init(path: String) throws {
        self.path = path
        try createLogFile()
    }

    public func createLogFile() throws {
        try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
    }

    public func appendLog(contents: String) {
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(Data((contents + "\n").utf8))
            fileHandle.closeFile()
        }
    }

    public func readLog() -> String? {
        return try? String(contentsOfFile: path)
    }
}