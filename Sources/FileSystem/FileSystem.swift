import Foundation

public protocol FileSystem {
    func contentsOfDirectory(atPath path: String) throws -> [String]
    func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool
    func contents(atPath path: String) -> Data?
    func partialContents(atPath path: String, range: Range<Int>) -> Data?
    func fileSize(atPath path: String) -> Int?
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

    public func fileSize(atPath path: String) -> Int? {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            let fileSize = attr[FileAttributeKey.size] as! UInt64
            return Int(fileSize)
        } catch {
            return nil
        }
    }

    public func contents(atPath path: String) -> Data? {
        return FileManager.default.contents(atPath: path)
    }

    public func partialContents(atPath path: String, range: Range<Int>) -> Data? {
        guard let size = fileSize(atPath: path) else {
            return nil
        }
        if range.upperBound > size {
            return nil
        }
        if let fileContents = FileManager.default.contents(atPath: path) {
            return fileContents.subdata(in: range)
        }
        return nil
    }
}
