import Routes
import SimpleURL
import FileSystem
import AppRoutes
import MiddleWare

public func createSwiftApp(directory: String, portNumber: Int) -> App {

    let app = App(
            directory: directory,
            portNumber: portNumber,
            fileManager: ServerFileManager(),
            logPath: "/server.log",
            hostName: "0.0.0.0",
            middleWare: MiddlewareExecutor()
    )

    let credentials = Auth(credentials: ["admin": "hunter2"])

//  Add Routes
    app.addRoute(route: AdminRoute.self, name: "/admin", methods: ["GET"])
    app.addRoute(route: RedirectRoute.self, name: "/redirect", newRoute: "/")
    app.addRoute(route: LogRoute.self, name: "/logs", methods: ["GET"],
            directory: app.fileManager.currentDirectoryPath(), baseName: "/server.log")
    app.addRoute(route: PatchRoute.self, name: "/patch-content.txt", methods: ["GET", "PATCH"],
            baseName: "/patch-content.txt")
    app.addRoute(route: CookieRoute.self, name: "/cookie", methods: ["GET"])
    app.addRoute(route: EatCookieRoute.self, name: "/eat_cookie", methods: ["GET"])
    app.addRoute(route: FormRoute.self, name: "/form", methods: ["GET", "POST", "PUT", "DELETE"])
    app.addRoute(route: ParametersRoute.self, name: "/parameters", methods: ["GET"])
    app.addRoute(route: MethodOptions.self, name: "/method_options", methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"])
    app.addRoute(route: MethodOptions2.self, name: "/method_options2", methods: ["GET", "OPTIONS"])
    app.addRoute(route: CoffeeRoute.self, name: "/coffee", methods: ["GET"])
    app.addRoute(route: TeaRoute.self, name: "/tea", methods: ["GET"])

//  Add MiddleWare
    app.middleware!.addMiddleWare(middleWare: LoggerMiddleware(logPath:
    simpleURL(path: app.fileManager.currentDirectoryPath(), baseName: "/server.log")))
    app.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/logs")
    app.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/admin")

    return app

}
