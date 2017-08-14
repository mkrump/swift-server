import Foundation
import SimpleURL
import Templates
import FileSystem

public func fileToMessage(isDir: Bool, fileManager: FileSystem, url: simpleURL, range: Range<Int> = 0..<0) -> Data {
    if isDir {
        guard let dir = try? fileManager.contentsOfDirectory(atPath: url.fullName) else {
            return Data()
        }
        return Data(dirListing(url: url, directories: dir).utf8)
    } else if !range.isEmpty {
        return fileManager.partialContents(atPath: url.fullName, range: range)!
    } else if let file = fileManager.contents(atPath: url.fullName) {
        return file
    }
    return Data()
}
