import Foundation
import HTTPResponse
import HTTPRequest
import SimpleURL
import FileSystem
import Templates
import Routes

public class LogRoute: Route {
    public var name: String
    public var methods: [String]
    var userName: String
    var password: String
    var logPath: simpleURL?
    var fileManager: FileSystem

    public init(name: String, methods: [String], fileManager: FileSystem, logPath: simpleURL? = nil) {
        self.name = name
        self.methods = methods
        self.userName = "admin"
        self.password = "hunter2"
        self.logPath = logPath
        self.fileManager = fileManager
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        if !authSuccess(headers: request.headers, userName: userName, password: password) {
            return CommonResponses.UnauthorizedResponse(realmName: name)
        }

        if let logPath = logPath {
            let content = fileToMessage(isDir: false, fileManager: fileManager, url: logPath)
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK).setMessage(message: content)
        }
        return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK)
    }
}


