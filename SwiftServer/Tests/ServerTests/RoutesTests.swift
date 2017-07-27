import XCTest
import Socket
import HTTPResponse
import FileSystem
@testable import Server

struct MockRoute: Route {
    var url: String
    var methods: [String] = []
    var requestHandler: () -> HTTPResponse

    func handleRequest(method: String) -> HTTPResponse {
        return requestHandler()
    }
}

public class MockFileManager: FileSystem {

    public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return ["dir1", "dir2"]
    }

    public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return true
    }

    public func contents(atPath path: String) -> Data? {
        return Data("Hi!".utf8)
    }
}

public class MockNoFile: MockFileManager {
    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return false
    }
}

public class MockIsDir: MockFileManager {
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
    var mockFileManager: MockFileManager!

    override func setUp() {
        mockFileManager = MockFileManager()
        routes = Routes()
        mockValidRoute = MockRoute(url: "/valid",
                methods: ["HEAD"],
                requestHandler: { () -> HTTPResponse in
                    return HTTPResponse().setResponseCode(responseCode: ResponseCodes.OK)
                })
        routes.addRoute(route: mockValidRoute)
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testBadRoute() {
        let mockNoDirFileManager = MockNoFile()
        let response = routes.routeRequest(target: "/no-route-here", method: "HEAD", path: "/public",
                fileManager: mockNoDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 404)
    }

    func testGoodRouteNotFile() {
        let mockNoDirFileManager = MockNoFile()
        let response = routes.routeRequest(target: "/valid", method: "HEAD", path: "/public",
                fileManager: mockNoDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 200)
    }

    func testisDir() {
        let mockNoDirFileManager = MockIsDir()
        let response = routes.routeRequest(target: "/dir", method: "HEAD", path: "/public",
                fileManager: mockNoDirFileManager)
        XCTAssertEqual(response.responseCode!.code, 200)
    }

    func testisFile() {
        let mockFileManager = MockFileManager()
        let response = routes.routeRequest(target: "/dir", method: "HEAD", path: "/file.txt",
                fileManager: mockFileManager)
        XCTAssertEqual(response.responseCode!.code, 200)
    }
}
