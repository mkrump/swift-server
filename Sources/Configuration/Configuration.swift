import Routes
import SimpleURL
import FileSystem
import AppRoutes
import MiddleWare

public func createSwiftApp(directory: String, portNumber: Int) -> AppConfig {

    let appConfig = AppConfig(
            directory: directory,
            portNumber: portNumber,
            fileManager: ServerFileManager(),
            logPath: "/server.log",
            hostName: "0.0.0.0",
            middleWare: MiddlewareExecutor()
    )

    let credentials = Auth(credentials: ["admin": "hunter2"])

    appConfig.addRoute(route: AdminRoute.self, name: "/admin", methods: ["GET"])
    appConfig.addRoute(route: RedirectRoute.self, name: "/redirect", newRoute: "/")
    appConfig.addRoute(route: LogRoute.self, name: "/logs", methods: ["GET"], baseName: "/server.log")
    appConfig.addRoute(route: PatchRoute.self, name: "/patch-content.txt", methods: ["GET", "PATCH"], baseName: "/patch-content.txt")
    appConfig.addRoute(route: CookieRoute.self, name: "/cookie", methods: ["GET"])
    appConfig.addRoute(route: EatCookieRoute.self, name: "/eat_cookie", methods: ["GET"])
    appConfig.addRoute(route: FormRoute.self, name: "/form", methods: ["GET", "POST", "PUT", "DELETE"])
    appConfig.addRoute(route: ParametersRoute.self, name: "/parameters", methods: ["GET"])
    appConfig.addRoute(route: MethodOptions.self, name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"])
    appConfig.addRoute(route: MethodOptions2.self, name: "/method_options2", methods: ["GET", "OPTIONS"])
    appConfig.addRoute(route: CoffeeRoute.self, name: "/coffee", methods: ["GET"])
    appConfig.addRoute(route: TeaRoute.self, name: "/tea", methods: ["GET"])
    appConfig.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/logs")
    appConfig.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/admin")

    return appConfig

}
