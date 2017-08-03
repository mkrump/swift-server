import Foundation
import HTTPResponse
import FileSystem
import Routes

func createVirtualRoutes(path: String, fileManager: FileSystem) -> [Route] {
    return [
        FormRoute(name: "/form", methods: ["GET", "POST", "PUT", "DELETE"]),
        ParametersRoute(name: "/parameters", methods: ["GET"]),
        MethodOptions(name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]),
        MethodOptions2(name: "/method_options2", methods: ["GET", "OPTIONS"]),
        CoffeeRoute(name: "/coffee", methods: ["GET"]),
        TeaRoute(name: "/tea", methods: ["GET"]),
        LogRoute(name: "/logs", methods: ["GET"]),
        RedirectRoute(name: "/redirect", newRoute: "/"),
        PatchRoute(url: simpleURL(path: path, baseName: "/patch-content.txt"), methods: ["GET", "PATCH"], fileManager: fileManager)
    ]
}

public func setupRoutes(path: String, fileManager: FileSystem) -> Routes {
    let serverRoutes = Routes()
    let virtualRoutes = createVirtualRoutes(path: path, fileManager: fileManager)
    for route in virtualRoutes {
        serverRoutes.addRoute(route: route)
    }
    return serverRoutes
}
