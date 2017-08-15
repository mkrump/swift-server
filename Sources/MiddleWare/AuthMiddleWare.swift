import SimpleURL
import FileSystem
import HTTPRequest
import HTTPResponse
import Foundation

public struct Auth {
    let credentials: [String: String]

    public init(credentials: [String: String]) {
        self.credentials = credentials
    }

    public func authorized(userNameAttempt: String, passwordAttempt: String) -> Bool {
        if let password = credentials[userNameAttempt] {
            return password == passwordAttempt
        }
        return false
    }
}

public class AuthMiddleware: Invokable {
    var auth: Auth
    var routes: [String]?

    public init(auth: Auth) {
        self.auth = auth
    }

    func getCredentials(headers: HeaderParse?) -> (userName: String?, passWord: String?)? {
        guard let headers = headers,
              let headerDict = headers.headerDict,
              let base64EncodedCredentials = headerDict["Authorization"],
              let credentials = decodeBasicAuth(challengeResponse: base64EncodedCredentials) else {
            return nil
        }
        return (userName: credentials.userName, passWord: credentials.passWord)
    }

    public func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) ->
            MiddlewareResponse {
        let response = CommonResponses.UnauthorizedResponse(realmName: url.path)
        guard let credentials = getCredentials(headers: request.headers),
              let userName = credentials.userName,
              let password = credentials.passWord else {
            return MiddlewareResponse(response: response, request: request)
        }
        if auth.authorized(userNameAttempt: userName, passwordAttempt: password) {
            return MiddlewareResponse(response: nil, request: request)
        }
        return MiddlewareResponse(response: response, request: request)
    }
}