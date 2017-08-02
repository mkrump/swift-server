import Foundation
import HTTPResponse
import Routes

func createVirtualRoutes(path: String) -> [Route] {
    return [
        FormRoute(name: "/form", methods: ["GET", "POST", "PUT", "DELETE"]),
        ParametersRoute(name: "/parameters", methods: ["GET"]),
        MethodOptions(name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]),
        MethodOptions2(name: "/method_options2", methods: ["GET", "OPTIONS"]),
        CoffeeRoute(name: "/coffee", methods: ["GET"]),
        TeaRoute(name: "/tea", methods: ["GET"]),
        RedirectRoute(name: "/redirect", newRoute: "/"),
        PatchRoute(name: "/patch-content.txt", methods: ["GET", "PATCH"], path: path)
    ]
}

public func setupRoutes(path: String) -> Routes {
    let serverRoutes = Routes()
    let virtualRoutes = createVirtualRoutes(path: path)
    for route in virtualRoutes {
        serverRoutes.addRoute(route: route)
    }
    return serverRoutes
}
