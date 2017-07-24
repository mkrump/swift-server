import HTTPResponse

public class Routes {
    var routes: [String: Route]

    public init() {
        routes = [:]
    }

    public func addRoute(route: Route) {
        if routes.keys.contains(route.url) {
            return
        }
        routes.updateValue(route, forKey: route.url)
    }

    public func removeRoute(route: Route) {
        routes.removeValue(forKey: route.url)
    }

    public func routeRequest(target: String, method: String) -> HTTPResponse {
        if let route = routes[target] {
            return route.handleRequest(method: method)
        }
        return HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.NOT_FOUND)
    }
}
