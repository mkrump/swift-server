import Foundation
import HTTPResponse
import Templates
import FileSystem

class FileRoute: Route {
    var name: String
    var methods: [String]
    var isDir: ObjCBool
    var routeContent: Data!

    init(name: String, isDir: ObjCBool, fileManager: FileSystem, fullPath: String) {
        self.name = name
        self.methods = ["GET", "HEAD"]
        self.isDir = isDir
        self.routeContent = fileToMessage(isDir: isDir, fileManager: fileManager, url: fullPath)
    }

    private func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, url: String) -> Data {
        if isDir.boolValue {
            guard let dir = try? fileManager.contentsOfDirectory(atPath: url) else {
                return Data()
            }
            return Data(dirListing(target: url, directories: dir).utf8)
        } else if let file = fileManager.contents(atPath: url) {
            return file
        }
        return Data()
    }

    func handleRequest(method: String, data: Data = Data(), params: [String: String]? = nil) -> HTTPResponse {
        return CommonResponses.OKResponse.setMessage(message: routeContent)
    }
}
