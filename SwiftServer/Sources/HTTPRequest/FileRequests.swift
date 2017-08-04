import Foundation
import FileSystem
import Templates

public func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, fullPath: String, range: Range<Int> = 0..<0) -> Data {
    if isDir.boolValue {
        guard let dir = try? fileManager.contentsOfDirectory(atPath: fullPath) else {
            return Data()
        }
        return Data(dirListing(target: fullPath, directories: dir).utf8)
    } else if !range.isEmpty {
        return fileManager.partialContents(atPath: fullPath, range: range)!
    } else if let file = fileManager.contents(atPath: fullPath) {
        return file
    }
    return Data()
}
