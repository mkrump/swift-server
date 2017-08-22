import Foundation
import FileSystem
import SimpleURL
import HTTPResponse
import Routes
import MiddleWare
import AppRoutes

public struct App {
    public var directory: String
    public var portNumber: Int
    public var fileManager: FileSystem
    public var logPath: String?
    public var hostName: String
    public var serverRoutes: Routes
    public var middleware: MiddlewareExecutor?
    public var auth: ((Route) -> AuthMiddleware)?

    public init(directory: String, portNumber: Int, fileManager: FileSystem,
                logPath: String? = nil, hostName: String, auth: ((Route) -> AuthMiddleware)? = nil,
                middleWare: MiddlewareExecutor? = nil) {
        self.directory = directory
        self.portNumber = portNumber
        self.fileManager = fileManager
        self.logPath = logPath
        self.hostName = hostName
        self.auth = auth
        self.middleware = middleWare
        serverRoutes = Routes()
    }

    public func addRoute<T:Virtual>(route: T.Type, name: String, methods: [String]) {
        let route = route.init(name: name, methods: methods)
        serverRoutes.addRoute(route: route)
    }

    public func addRoute<T:Redirect>(route: T.Type, name: String, newRoute: String) {
        let route = route.init(name: name, newRoute: newRoute)
        serverRoutes.addRoute(route: route)
    }

    public func addRoute<T:NonVirtual>(route: T.Type, name: String, methods: [String],
                                       baseName: String, isDir: Bool? = false, mimeType: String? = nil) {
        let url = simpleURL(path: directory, baseName: baseName)
        let fileMimeType = mimeType ?? inferContentType(fileName: url.fullName)
        let route = route.init(name: name, methods: methods, url: url, fileManager: fileManager,
                isDir: isDir, mimeType: fileMimeType)
        serverRoutes.addRoute(route: route)
    }
}
