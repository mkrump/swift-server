import Routes

public func setupRoutes() -> Routes {
    let serverRoutes = Routes()
    serverRoutes.addRoute(route: RootRoute(url: "/", methods: ["GET", "POST", "PUT"]))
    serverRoutes.addRoute(route: FormRoute(url: "/form", methods: ["GET", "POST", "PUT"]))
    serverRoutes.addRoute(route: MethodOptions(url: "/method_options",
            methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]))
    serverRoutes.addRoute(route: MethodOptions2(url: "/method_options2", methods: ["GET", "OPTIONS"]))
    serverRoutes.addRoute(route: RedirectRoute(url: "/redirect", methods: ["GET"]))
    return serverRoutes
}
