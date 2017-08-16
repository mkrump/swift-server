import Foundation
import HTTPResponse
import HTTPRequest
import SimpleURL
import FileSystem
import Templates
import MiddleWare

public class Routes {
    var routes: [String: Route]

    public init() {
        routes = [:]
    }

    public func addRoute(route: Route) {
        routes.updateValue(route, forKey: route.name)
    }

    public func getRoute(routeName: String) -> Route? {
        if let route = routes[routeName] {
            return route
        }
        return nil
    }

    public func removeRoute(route: Route) {
        routes.removeValue(forKey: route.name)
    }

    private func isValidRoute(routes: [String: Route], url: simpleURL, fileManager: FileSystem) -> Route? {
        var isDir = ObjCBool(false)
        if let route = routes[url.baseName] {
            return route
        } else if fileManager.fileExists(atPath: url.fullName, isDirectory: &isDir) {
            let isDirBool = isDir.description == "true" ? true : false
            return FileRoute(url: url, isDir: isDirBool, fileManager: fileManager)
        }
        return nil
    }

    private func getResponse(route: inout Route, request: HTTPRequestParse) -> HTTPResponse {
        if route.methodAllowed(method: request.requestLine.httpMethod) {
            return route.handleRequest(request: request)
        } else {
            return CommonResponses.MethodNotAllowedResponse(methods: route.methods)
        }
    }

    public func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> HTTPResponse {
        return routeRequest(request: request, url: url, fileManager: fileManager)
    }

    public func routeRequest(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> HTTPResponse {
        if var route = isValidRoute(routes: routes, url: url, fileManager: fileManager) {
            return getResponse(route: &route, request: request)
        } else {
            return CommonResponses.NotFoundResponse()
        }
    }
}
