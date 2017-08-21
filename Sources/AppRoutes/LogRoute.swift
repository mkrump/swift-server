import Foundation
import HTTPResponse
import HTTPRequest
import SimpleURL
import FileSystem
import Templates
import Routes

public class LogRoute: NonVirtual {
    public required init(name: String, methods: [String], url: simpleURL, fileManager: FileSystem, isDir: Bool?, mimeType: String?) {
        self.name = name
        self.methods = methods
        self.logPath = url
        self.fileManager = fileManager
    }

    public var name: String
    public var methods: [String]
    var logPath: simpleURL?
    var fileManager: FileSystem

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        if let logPath = logPath {
            let content = fileToMessage(isDir: false, fileManager: fileManager, url: logPath)
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK).setMessage(message: content)
        }
        return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK)
    }
}
