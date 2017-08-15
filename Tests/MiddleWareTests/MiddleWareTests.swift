import XCTest
import HTTPResponse
import HTTPRequest
import FileSystem
import SimpleURL
import Routes
@testable import MiddleWare

class MiddleWareTests: XCTestCase {
    var routes: Routes!
    var mockValidRoute: Route!
    var mockRedirectRoute: Route!
    var mockFileManager: MockIsRoute!
    var path: String!
    var auth: Auth!
    var secondStepAuth: Auth!

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
        secondStepAuth = Auth(credentials: ["admin": "admin"])
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func generateMockResponses(userNameAttempt: String?, passwordAttempt: String?, target: String) -> HTTPResponse {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: target, httpVersion: "HTTTP/1.1")
        let mockHTTPParse: MockHTTParsedRequest
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

    func testMultipleAuthFail() {
        var updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: secondStepAuth)
        routes.addRoute(route: updatedRoute)
        let response = generateMockResponses(userNameAttempt: "abc", passwordAttempt: "123", target: "/valid")
        XCTAssertEqual(response.responseCode!.code, 401)
    }

    func testMultipleAuthPass() {
        var updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        updatedRoute = AuthMiddleWare(route: mockValidRoute, auth: auth)
        routes.addRoute(route: updatedRoute)
        let response = generateMockResponses(userNameAttempt: "abc", passwordAttempt: "123", target: "/valid")
        XCTAssertEqual(response.responseCode!.code, 200)
    }
}
