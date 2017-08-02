import Foundation
import FileSystem
import Templates

public func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, url: String, range: Range<Int> = 0..<0) -> Data {
    if isDir.boolValue {
        guard let dir = try? fileManager.contentsOfDirectory(atPath: url) else {
            return Data()
        }
        return Data(dirListing(target: url, directories: dir).utf8)
    } else if !range.isEmpty {
        return fileManager.partialContents(atPath: url, range: range)!
    } else if let file = fileManager.contents(atPath: url) {
        return file
    }
    return Data()
}
