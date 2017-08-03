import Foundation
import HTTPResponse
import HTTPRequest
import FileSystem
import Templates
import Routes

class LogRoute: Route {
    var name: String
    var methods: [String]
    var userName: String
    var password: String
    var logPath: String?
    var fileManager: FileSystem

    init(name: String, methods: [String], fileManager: FileSystem, logPath: String? = nil) {
        self.name = name
        self.methods = methods
        self.userName = "admin"
        self.password = "hunter2"
        self.logPath = logPath
        self.fileManager = fileManager
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        if !authSuccess(headers: request.headers, userName: userName, password: password) {
            return CommonResponses.UnauthorizedResponse(realmName: name)
        }

        if let logPath = logPath {
            let content = fileToMessage(isDir: ObjCBool(false), fileManager: fileManager, fullPath: logPath)
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK).setMessage(message: content)
        }
        return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK)
    }
}
