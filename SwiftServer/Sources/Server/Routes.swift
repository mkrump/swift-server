import Foundation
import HTTPResponse
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

    public func routeRequest(target: String, method: String, path: String, fileManager: FileSystem) -> HTTPResponse {
        var isDir: ObjCBool = false
        let url = path + target
        if fileManager.fileExists(atPath: url, isDirectory: &isDir) {
            let message = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
            return CommonResponses.OKResponse.setMessage(message: message)
        } else if let route = routes[target] {
            return route.handleRequest(method: method)
        }
        return CommonResponses.NotFoundResponse
    }
}
