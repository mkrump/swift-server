import HTTPResponse

public protocol Route {
    var url: String { get }
    var methods: [String] { get }
    func handleRequest(method: String) -> HTTPResponse
}

func optionsResponse(methods: [String]) -> HTTPResponse {
    return   HTTPResponse()
            .setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.OK)
            .addHeader(key: "Allow", value: methods.joined(separator: ","))
}

struct RootRoute: Route {
    var url: String
    var methods: [String]

    func handleRequest(method: String) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
                .setMessage(message: "Hello!")
    }

}

struct methodOptions: Route {
    var url: String
    var methods: [String]

    func handleRequest(method: String) -> HTTPResponse {
        if method == "OPTIONS" {
            return optionsResponse(methods: methods)
        }
        return   HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
    }
}

struct methodOptions2: Route {
    var url: String
    var methods: [String]

    func handleRequest(method: String) -> HTTPResponse {
        if method == "OPTIONS" {
            return optionsResponse(methods: methods)
        }
        return   HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
    }
}

func setupRoutes() -> Routes {
    let serverRoutes = Routes()
    serverRoutes.addRoute(route: RootRoute(url: "/",
            methods: ["GET", "POST", "PUT"]))
    serverRoutes.addRoute(route: RootRoute(url: "/form",
            methods: ["GET", "POST", "PUT"]))
    serverRoutes.addRoute(route: methodOptions(url: "/method_options",
            methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]))
    serverRoutes.addRoute(route: methodOptions2(url: "/method_options2",
            methods: ["GET", "OPTIONS"]))
    return serverRoutes
}
