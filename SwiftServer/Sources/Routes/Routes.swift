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
        if routes.keys.contains(route.url) {
            return
        }
        routes.updateValue(route, forKey: route.url)
    }

    public func removeRoute(route: Route) {
        routes.removeValue(forKey: route.url)
    }

    private func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, url: String) -> Data {
        if isDir.boolValue {
            guard let dir = try? fileManager.contentsOfDirectory(atPath: url) else {
                return Data()
            }
            return Data(dirListing(target: url, directories: dir).utf8)
        } else if let file = fileManager.contents(atPath: url) {
            return file
        }
        return Data()
    }

    private func isValidRoute(routes: [String: Route], target: String) -> Route? {
        if let route = routes[target] {
            return route
        }
        return nil
    }

    public func routeRequest(request: HTTPRequestParse, path: String, fileManager: FileSystem) -> HTTPResponse {
        let startLine = request.startLine!
        let data = request.messageBody ?? ""
        let url = path + startLine.target
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: url, isDirectory: &isDir) {
            let message = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
            return CommonResponses.OKResponse.setMessage(message: message)
        } else if var route = isValidRoute(routes: routes, target: startLine.target) {
            return route.handleRequest(method: startLine.httpMethod, data: Data(data.utf8))
        } else {
            return CommonResponses.NotFoundResponse
        }
    }
}
