import XCTest
import HTTPResponse
import HTTPRequest
import FileSystem
@testable import Routes

struct MockRoute: Route {
    var name: String
    var methods: [String] = []
    var requestHandler: (String, Data) -> HTTPResponse

    func handleRequest(method: String, data: Data = Data(), params: [String: String]? = nil) -> HTTPResponse {
        return requestHandler(method, data)
    }
}

public class MockRequestLine: RequestLineParse {
    public var httpMethod: String!
    public var target: String!
    public var params: [String: String]?
    public var httpVersion: String!

    init(httpMethod: String, target: String, httpVersion: String) {
        self.httpMethod = httpMethod
        self.target = target
        self.httpVersion = httpVersion
    }
}

public class MockHTTParsedRequest: HTTPRequestParse {
    public var startLine: RequestLineParse!
    public var headers: String?
    public var messageBody: String?

    init(startLine: RequestLineParse, headers: String? = nil, messageBody: String? = nil) {
        self.headers = headers
        self.messageBody = messageBody
        self.startLine = startLine
    }

}

public class MockIsRoute: FileSystem {
    public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return false
    }

    public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return []
    }

    public func contents(atPath path: String) -> Data? {
        return nil
    }
}

public class MockIsFile: MockIsRoute {

    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return true
    }

    override public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return ["dir1", "dir2"]
    }

    override public func contents(atPath path: String) -> Data? {
        return Data("Hi!".utf8)
    }
}

public class MockIsDir: MockIsRoute {
    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = true
        }
        return true
    }
}

class RoutesTests: XCTestCase {
    var routes: Routes!
    var mockValidRoute: Route!
    var mockFileManager: MockIsRoute!
    var path: String!

    override func setUp() {
        path = "public"
        mockFileManager = MockIsRoute()
        routes = Routes()
        mockValidRoute = MockRoute(name: "/valid",
                methods: ["HEAD", "GET"],
                requestHandler: { (_: String, _: Data) -> HTTPResponse in
                    return CommonResponses.OKResponse
                })
        routes.addRoute(route: mockValidRoute)
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testBadRoute() {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: "/no-route-here", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockNoDirFileManager = MockIsRoute()
        let url = URL(path: "/public", baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 404)
    }

    func testGoodRouteNotFile() {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: "/valid", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockNoDirFileManager = MockIsRoute()
        let url = URL(path: path, baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 200)
    }

    func testisDir() {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: "/dir", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockDirFileManager = MockIsDir()
        let url = URL(path: path, baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 200)
    }

    func testisFile() {
        let mockStartLine = MockRequestLine(httpMethod: "GET", target: "/file.txt", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockFileManager = MockIsFile()
        let url = URL(path: "/public", baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockFileManager)
        if let httpMessage = String(data: response.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(response.responseCode!.code, 200)
            XCTAssertTrue(httpMessage.contains("Content-Type: text/plain"))
        } else {
            XCTFail()
        }
    }

    func testRedirect() {
        let mockStartLine = MockRequestLine(httpMethod: "GET", target: "/old_route_location", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockFileManager = MockIsRoute()
        let url = URL(path: "/public", baseName: mockStartLine.target)
        let mockRedirectRoute = MockRoute(name: "/old_route_location",
                methods: ["GET"],
                requestHandler: { (_: String, _: Data) -> HTTPResponse in
                    return CommonResponses.FoundResponse(newLocation: "/new_location")
                })
        routes.addRoute(route: mockRedirectRoute)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockFileManager)
        if let httpMessage = String(data: response.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(response.responseCode!.code, 302)
            XCTAssertTrue(httpMessage.contains("Location: /new_location"))
        } else {
            XCTFail()
        }
    }

    func testNotAllowedFile() {
        let mockStartLine = MockRequestLine(httpMethod: "POST", target: "/file.txt", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockFileManager = MockIsFile()
        let url = URL(path: "/public", baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockFileManager)
        if let httpMessage = String(data: response.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(response.responseCode!.code, 405)
            XCTAssertTrue(httpMessage.contains("Allow: GET,HEAD"))
        } else {
            XCTFail()
        }
    }

    func testNotAllowedRoute() {
        let mockStartLine = MockRequestLine(httpMethod: "POST", target: "/valid", httpVersion: "HTTP/1.1")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockFileManager = MockIsRoute()
        let url = URL(path: "/public", baseName: mockStartLine.target)
        let response = routes.routeRequest(request: mockHTTPParse, url: url, fileManager: mockFileManager)
        if let httpMessage = String(data: response.generateResponse(), encoding: String.Encoding.utf8) {
            XCTAssertEqual(response.responseCode!.code, 405)
            XCTAssertTrue(httpMessage.contains("Allow: HEAD,GET"))
        } else {
            XCTFail()
        }
    }
}
