import XCTest
import HTTPResponse
import HTTPRequest
import FileSystem
import SimpleURL
@testable import Routes

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

    init(route: Route, auth: Auth) {
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

class MiddleWareTests: XCTestCase {
    var routes: Routes!
    var mockValidRoute: Route!
    var mockRedirectRoute: Route!
    var mockFileManager: MockIsRoute!
    var path: String!
    var auth: Auth!

    override func setUp() {
        path = "public"
        mockFileManager = MockIsRoute()
        routes = Routes()
        mockValidRoute = MockRoute(name: "/valid",
                methods: ["HEAD", "GET"],
                requestHandler: { (_: HTTPRequestParse) -> HTTPResponse in
                    return CommonResponses.OKResponse()
                })
        routes.addRoute(route: mockValidRoute)
        auth = Auth(credentials: ["abc": "123"])
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func generateMockResponses(userNameAttempt: String?, passwordAttempt: String?, target: String) -> HTTPResponse {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: target, httpVersion: "HTTTP/1.1")
        let mockHTTPParse : MockHTTParsedRequest
        if userNameAttempt != nil && passwordAttempt != nil {
            let base64EncodedString = Data((userNameAttempt! + ":" + passwordAttempt!).utf8).base64EncodedString()
            let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic " + base64EncodedString,
                    headerDict: ["Authorization": "Basic " + base64EncodedString])
            mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine, headers: mockHeaders)
        } else {
            mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine, headers: nil)
        }
        let mockNoDirFileManager = MockIsRoute()
        let url = simpleURL(path: path, baseName: mockStartLine.target)
        return routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
    }

    func testBadLogin() {
        let userNameAttempt = "admin"
        let passwordAttempt = "admin"
        let updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        routes.addRoute(route: updatedRoute)
        let response = generateMockResponses(userNameAttempt: userNameAttempt,
                passwordAttempt: passwordAttempt, target: "/valid")
        XCTAssertEqual(response.responseCode!.code, 401)
    }

    func testGoodLogin() {
        let userNameAttempt = "abc"
        let passwordAttempt = "123"
        let updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        routes.addRoute(route: updatedRoute)
        let response = generateMockResponses(userNameAttempt: userNameAttempt,
                passwordAttempt: passwordAttempt, target: "/valid")
        XCTAssertEqual(response.responseCode!.code, 200)
    }

    func testNoAuthHeader() {
        let updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        routes.addRoute(route: updatedRoute)
        let response = generateMockResponses(userNameAttempt: nil, passwordAttempt: nil, target: "/valid")
        XCTAssertEqual(response.responseCode!.code, 401)
    }
}
