import Foundation
import HTTPResponse
import Routes

public func setupRoutes() -> Routes {
    let serverRoutes = Routes()
    serverRoutes.addRoute(route: FormRoute(name: "/form", methods: ["GET", "POST", "PUT", "DELETE"]))
    serverRoutes.addRoute(route: ParametersRoute(name: "/parameters", methods: ["GET"]))
    serverRoutes.addRoute(route: MethodOptions(name: "/method_options",
            methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]))
    serverRoutes.addRoute(route: MethodOptions2(name: "/method_options2", methods: ["GET", "OPTIONS"]))
    serverRoutes.addRoute(route: CoffeeRoute(name: "/coffee", methods: ["GET"]))
    serverRoutes.addRoute(route: TeaRoute(name: "/tea", methods: ["GET"]))
    serverRoutes.addRoute(route: RedirectRoute(name: "/redirect", newRoute: "/"))
    serverRoutes.addRoute(route: PatchRoute(name: "/partial.txt", fullPath: "/Users/mathewkrump/Server/cob_spec/public"))
    return serverRoutes
}

