import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class LogRoute: Route {
    var name: String
    var methods: [String]
    var userName: String
    var password: String
    var logData: Data

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.userName = "admin"
        self.password = "hunter2"
        self.logData = Data()
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        if !authSuccess(headers: request.headers, userName: userName, password: password) {
            return CommonResponses
                    .DefaultHeaders(responseCode: ResponseCodes.UNAUTHORIZED)
                    .addHeader(key: "WWW-Authenticate", value: "Basic realm=\"\(name)\"")
        }
        return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.OK)
    }
}
