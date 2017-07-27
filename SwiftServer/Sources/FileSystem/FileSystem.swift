import Foundation

public protocol FileSystem {
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
    func contents(atPath path: String) -> Data?
}

public class ServerFileManager: FileSystem {
    public init() {

    }

    public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return try FileManager.default.contentsOfDirectory(atPath: path)
    }

    public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        return FileManager.default.fileExists(atPath: path, isDirectory: isDirectory)
    }

    public func contents(atPath path: String) -> Data? {
        return FileManager.default.contents(atPath: path)
    }
}
