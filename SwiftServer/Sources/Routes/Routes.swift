import Foundation
import HTTPResponse
import HTTPRequest
import FileSystem
import Templates

public class Routes {
    var routes: [String: Route]

    public init() {
        routes = [:]
    }

    public func addRoute(route: Route) {
        if routes.keys.contains(route.name) {
            return
        }
        routes.updateValue(route, forKey: route.name)
    }

    public func removeRoute(route: Route) {
        routes.removeValue(forKey: route.name)
    }

    private func isValidRoute(routes: [String: Route], url: URL, fileManager: FileSystem) -> Route? {
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: url.fullName, isDirectory: &isDir) {
            return FileRoute(name: url.baseName, isDir: isDir, fileManager: fileManager, fullPath: url.fullName)
        } else if let route = routes[url.baseName] {
            return route
        }
        return nil
    }

    private func getResponse(route: inout Route, httpMethod: String, requestBody: String) -> HTTPResponse {
        if route.methodAllowed(method: httpMethod) {
            return route.handleRequest(method: httpMethod, data: Data(requestBody.utf8))
        } else {
            return CommonResponses.MethodNotAllowedResponse(methods: route.methods)
        }
    }

    public func routeRequest(request: HTTPRequestParse, url: URL, fileManager: FileSystem) -> HTTPResponse {
        let startLine = request.startLine!
        let requestBody = request.messageBody ?? ""
        if var route = isValidRoute(routes: routes, url: url, fileManager: fileManager) {
            return getResponse(route: &route, httpMethod: startLine.httpMethod, requestBody: requestBody)
        } else {
            return CommonResponses.NotFoundResponse
        }
    }
}
