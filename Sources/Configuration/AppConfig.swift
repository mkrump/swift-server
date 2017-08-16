import Foundation
import FileSystem
import SimpleURL
import Routes
import MiddleWare

public struct AppConfig {
    public var directory: String
    public var portNumber: Int
    public var fileManager: FileSystem
    public var logPath: String?
    public var hostName: String
    public var serverRoutes: Routes
    public var middleWare: InvokAble?
    public var auth: ((Route) -> AuthMiddleWare)?

    public init(directory: String, portNumber: Int, fileManager: FileSystem,
                logPath: String? = nil, hostName: String, auth: ((Route) -> AuthMiddleWare)? = nil,
                middleWare: InvokAble? = nil) {
        self.directory = directory
        self.portNumber = portNumber
        self.fileManager = fileManager
        self.logPath = logPath
        self.hostName = hostName
        self.auth = auth
        self.middleWare = middleWare
        serverRoutes = Routes()
    }
}

public func addRoutes(appConfig: AppConfig) -> Routes {
    let routes = Routes()
    let virtualRoutes = initializeRoutes(appConfig: appConfig)
    for route in virtualRoutes {
        routes.addRoute(route: route)
    }
    return routes
}