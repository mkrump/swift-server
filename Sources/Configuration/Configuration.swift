import Routes
import SimpleURL
import FileSystem
import AppRoutes
import MiddleWare

var creds = Auth(credentials: ["admin": "hunter2"])

public func initializeRoutes(appConfig: AppConfig) -> [Route] {
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
        AuthMiddleWare(
                route:
                LogRoute(name: "/logs", methods: ["GET"],
                        fileManager: appConfig.fileManager,
                        logPath: simpleURL(path: appConfig.directory, baseName: appConfig.logPath!)),
                auth: creds),
        RedirectRoute(name: "/redirect", newRoute: "/"),
        PatchRoute(url: simpleURL(path: appConfig.directory, baseName: "/patch-content.txt"),
                methods: ["GET", "PATCH"], fileManager: appConfig.fileManager)
    ]
}

public var appConfig = AppConfig(
        directory: "./",
        portNumber: 5000,
        fileManager: ServerFileManager(),
        logPath: "/server.log",
        hostName: "0.0.0.0"
)
