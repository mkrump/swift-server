import SimpleURL
import FileSystem
import HTTPRequest
import HTTPResponse

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

public protocol InvokAble {
    func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> HTTPResponse
}

public protocol MiddleWare {
    var next: InvokAble { get }
}

//TODO Add a terminal type of middleware that does not require next
//TODO use this type for last in pipeline
public class AuthMiddleWare: MiddleWare {
    public var next: InvokAble
    var auth: Auth

    public init(auth: Auth, next: InvokAble) {
        self.auth = auth
        self.next = next
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

    public func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> HTTPResponse {
        guard let credentials = getCredentials(headers: request.headers),
              let userName = credentials.userName,
              let password = credentials.passWord else {
            return CommonResponses.UnauthorizedResponse(realmName: url.path)
        }
        if auth.authorized(userNameAttempt: userName, passwordAttempt: password) {
            return next.invoke(request: request, url: url, fileManager: fileManager)
        }
        return CommonResponses.UnauthorizedResponse(realmName: url.path)
    }
}