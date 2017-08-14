import Foundation
import FileSystem
import Routes

public struct AppConfig {
    public var directory: String
    public var portNumber: Int
    public var fileManager: FileSystem
    public var logPath: String?
    public var hostName: String
    public var serverRoutes: Routes

    public init(directory: String, portNumber: Int, fileManager: FileSystem, logPath: String? = nil, hostName: String) {
        self.directory = directory
        self.portNumber = portNumber
        self.fileManager = fileManager
        self.logPath = logPath
        self.hostName = hostName
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
