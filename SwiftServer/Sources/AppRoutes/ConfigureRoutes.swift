import Foundation
import HTTPResponse
import FileSystem
import Routes

func createVirtualRoutes(path: String, fileManager: FileSystem, logPath: String? = nil) -> [Route] {
    return [
        CookieRoute(name: "/cookie", methods: ["GET"]),
        EatCookieRoute(name: "/eat_cookie", methods: ["GET"]),
        FormRoute(name: "/form", methods: ["GET", "POST", "PUT", "DELETE"]),
        MethodOptions(name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]),
        ParametersRoute(name: "/parameters", methods: ["GET"]),
        MethodOptions(name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]),
        MethodOptions2(name: "/method_options2", methods: ["GET", "OPTIONS"]),
        CoffeeRoute(name: "/coffee", methods: ["GET"]),
        TeaRoute(name: "/tea", methods: ["GET"]),
        LogRoute(name: "/logs", methods: ["GET"], fileManager: fileManager, logPath: logPath),
        RedirectRoute(name: "/redirect", newRoute: "/"),
        PatchRoute(url: simpleURL(path: path, baseName: "/patch-content.txt"), methods: ["GET", "PATCH"], fileManager: fileManager)
    ]
}

public func setupRoutes(path: String, fileManager: FileSystem, logPath: String? = nil) -> Routes {
    let serverRoutes = Routes()
    let virtualRoutes = createVirtualRoutes(path: path, fileManager: fileManager, logPath: logPath)
    for route in virtualRoutes {
        serverRoutes.addRoute(route: route)
    }
    return serverRoutes
}
