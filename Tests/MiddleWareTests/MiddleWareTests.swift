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
    var authMiddleware: AuthMiddleware!
    var middlewareExecutor: MiddlewareExecutor!
    var secondStepAuth: Auth!

    override func setUp() {
        path = "public"
        auth = Auth(credentials: ["abc": "123"])
        secondStepAuth = Auth(credentials: ["admin": "admin"])
        authMiddleware = AuthMiddleware(auth: auth)
        middlewareExecutor = MiddlewareExecutor()
        middlewareExecutor.addMiddleWare(middleWare: authMiddleware)
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func generateMockResponses(userNameAttempt: String?,
                               passwordAttempt: String?, target: String) -> MiddlewareResponse {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: target, httpVersion: "HTTTP/1.1", rawRequestLine: "")
        let mockHTTPParse = addBasicAuthHeader(userNameAttempt: userNameAttempt,
                passwordAttempt: passwordAttempt, mockStartLine: mockStartLine)
        let mockNoDirFileManager = MockIsRoute()
        let url = simpleURL(path: path, baseName: mockStartLine.target)
        return middlewareExecutor.execute(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
    }

    private func addBasicAuthHeader(userNameAttempt: String?, passwordAttempt: String?,
                                    mockStartLine: RequestLineParse) -> HTTPRequestParse {
        if userNameAttempt != nil && passwordAttempt != nil {
            let base64EncodedString = Data((userNameAttempt! + ":" + passwordAttempt!).utf8).base64EncodedString()
            let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic " + base64EncodedString,
                    headerDict: ["Authorization": "Basic " + base64EncodedString])
            return MockHTTParsedRequest(startLine: mockStartLine, headers: mockHeaders)
        } else {
            return MockHTTParsedRequest(startLine: mockStartLine, headers: nil)
        }
    }

    func testBadLogin() {
        let userNameAttempt = "admin"
        let passwordAttempt = "admin"
        let middlewareResponse = generateMockResponses(userNameAttempt: userNameAttempt,
                passwordAttempt: passwordAttempt, target: "/valid")
        if let response = middlewareResponse.response {
            XCTAssertEqual(response.responseCode!.code, 401)
        } else {
            XCTFail()
        }
    }

    func testGoodLogin() {
        let userNameAttempt = "abc"
        let passwordAttempt = "123"
        let middlewareResponse = generateMockResponses(userNameAttempt: userNameAttempt,
                passwordAttempt: passwordAttempt, target: "/valid")
        if middlewareResponse.response != nil {
            XCTFail()
        } else {
            XCTAssertNil(middlewareResponse.response)
            XCTAssertNotNil(middlewareResponse.request)
        }
    }

    func testNoAuthHeader() {
        let middlewareResponse = generateMockResponses(userNameAttempt: nil, passwordAttempt: nil, target: "/valid")
        if let response = middlewareResponse.response {
            XCTAssertEqual(response.responseCode!.code, 401)
        } else {
            XCTFail()
        }
    }

    func testMultipleAuthFail() {
        middlewareExecutor.addMiddleWare(middleWare: AuthMiddleware(auth: secondStepAuth))
        let middlewareResponse = generateMockResponses(userNameAttempt: "abc", passwordAttempt: "123", target: "/valid")
        if let response = middlewareResponse.response {
            XCTAssertEqual(response.responseCode!.code, 401)
        } else {
            XCTFail()
        }
    }

    func testMultipleAuthPass() {
        middlewareExecutor.addMiddleWare(middleWare: AuthMiddleware(auth: auth))
        let middlewareResponse = generateMockResponses(userNameAttempt: "abc", passwordAttempt: "123", target: "/valid")
        if middlewareResponse.response != nil {
            XCTFail()
        } else {
            XCTAssertNil(middlewareResponse.response)
            XCTAssertNotNil(middlewareResponse.request)
        }
    }
}
