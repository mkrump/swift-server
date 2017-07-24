import XCTest
import Socket
import HTTPResponse
@testable import Server

struct MockRoute: Route {
    var url: String
    var methods: [String] = []
    var requestHandler: () -> HTTPResponse

    func handleRequest(method: String) -> HTTPResponse {
        return requestHandler()
    }
}

class RoutesTests: XCTestCase {
    var routes: Routes!
    var mockValidRoute: Route!

    override func setUp() {
        routes = Routes()
        mockValidRoute = MockRoute(url: "/",
                methods: ["HEAD"],
                requestHandler: { () -> HTTPResponse in
                    return HTTPResponse().setResponseCode(responseCode: ResponseCodes.OK) })
        routes.addRoute(route: mockValidRoute)
        super.setUp()

    }

    override func tearDown() {
        super.tearDown()
    }

    func testBadRoute() {
        let response = routes.routeRequest(target: "/no-route-here", method: "HEAD")
        XCTAssertEqual(response.responseCode!.code, 404)
    }

    func testGoodRoute() {
        let response = routes.routeRequest(target: "/", method: "HEAD")
        XCTAssertEqual(response.responseCode!.code, 200)
    }
}
