import XCTest
import HTTPResponse
import HTTPRequest
import FileSystem
import SimpleURL
@testable import Routes

class RoutesTests: XCTestCase {
    var routes: Routes!
    var mockValidRoute: Route!
    var mockRedirectRoute: Route!
    var mockFileManager: MockIsRoute!
    var path: String!

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
        mockRedirectRoute = MockRoute(name: "/old_route_location",
                methods: ["GET"],
                requestHandler: { (_: HTTPRequestParse) -> HTTPResponse in
                    return CommonResponses.FoundResponse(newLocation: "/new_location")
                })
        routes.addRoute(route: mockRedirectRoute)
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func generateMockResponses(httpMethod: String, target: String, httpVersion: String? = "HTTP/1.1",
                               mockFileSystem: FileSystem) -> HTTPResponse {
        let mockStartLine = MockRequestLine(httpMethod: httpMethod, target: target, httpVersion: httpVersion!)
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockNoDirFileManager = mockFileSystem
        let url = simpleURL(path: path, baseName: mockStartLine.target)
        return routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
    }

    func testBadRoute() {
        let badRouteResponse = generateMockResponses(httpMethod: "HEAD",
                target: "/no-route-here", mockFileSystem: MockIsRoute())
        XCTAssertEqual(badRouteResponse.responseCode!.code, 404)
    }

    func testGoodRouteNotFile() {
        let goodRouteResponse = generateMockResponses(httpMethod: "HEAD",
                target: "/valid", mockFileSystem: MockIsRoute())
        XCTAssertEqual(goodRouteResponse.responseCode!.code, 200)
    }

    func testisDir() {
        let routeIsDirResponse = generateMockResponses(httpMethod: "HEAD", target: "/dir", mockFileSystem: MockIsDir())
        XCTAssertEqual(routeIsDirResponse.responseCode!.code, 200)
    }

    func testisFile() {
        let routeIsFileResponse = generateMockResponses(httpMethod: "GET", target: "/file.txt",
                mockFileSystem: MockIsFile())
        if let httpMessage = String(data: routeIsFileResponse.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(routeIsFileResponse.responseCode!.code, 200)
            XCTAssertTrue(httpMessage.contains("Content-Type: text/plain"))
        } else {
            XCTFail()
        }
    }

    func testRedirect() {
        let routeMovedResponse = generateMockResponses(httpMethod: "GET", target: "/old_route_location",
                mockFileSystem: MockIsRoute())
        if let httpMessage = String(data: routeMovedResponse.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(routeMovedResponse.responseCode!.code, 302)
            XCTAssertTrue(httpMessage.contains("Location: /new_location"))
        } else {
            XCTFail()
        }
    }

    func testNotAllowedFile() {
        let methodNotAllowedResponse = generateMockResponses(httpMethod: "POST", target: "/file.txt",
                mockFileSystem: MockIsFile())
        if let httpMessage = String(data: methodNotAllowedResponse.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(methodNotAllowedResponse.responseCode!.code, 405)
            XCTAssertTrue(httpMessage.contains("Allow: GET,HEAD"))
        } else {
            XCTFail()
        }
    }

    func testNotAllowedRoute() {
        let methodNotAllowedResponse = generateMockResponses(httpMethod: "POST", target: "/valid",
                mockFileSystem: MockIsRoute())
        if let httpMessage = String(data: methodNotAllowedResponse.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(methodNotAllowedResponse.responseCode!.code, 405)
            XCTAssertTrue(httpMessage.contains("Allow: HEAD,GET"))
        } else {
            XCTFail()
        }
    }
}
