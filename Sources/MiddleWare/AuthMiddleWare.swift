import Routes
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

public class AuthMiddleWare: Route {
    var route: Route
    var auth: Auth
    public var name: String
    public var methods: [String]

    public init(route: Route, auth: Auth) {
//  TODO remove route from here and add
//  TODO addRoute function to attach the route
        self.route = route
        self.auth = auth
        self.name = route.name
        self.methods = route.methods
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

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        guard let credentials = getCredentials(headers: request.headers),
              let userName = credentials.userName,
              let password = credentials.passWord else {
            return CommonResponses.UnauthorizedResponse(realmName: route.name)
        }
        if auth.authorized(userNameAttempt: userName, passwordAttempt: password) {
            return route.handleRequest(request: request)
        }
        return CommonResponses.UnauthorizedResponse(realmName: route.name)
    }
}