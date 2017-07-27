import Foundation
import HTTPResponse
import Templates

public protocol Route {
    var url: String { get }
    var methods: [String] { get }
    mutating func handleRequest(method: String, data: Data) -> HTTPResponse
}

func optionsResponse(methods: [String]) -> HTTPResponse {
    return   HTTPResponse()
            .setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.OK)
            .addHeader(key: "Allow", value: methods.joined(separator: ","))
}

class RootRoute: Route {
    var url: String
    var methods: [String]

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
                .setMessage(message: Data("Hello!".utf8))
    }
}

class FormRoute: Route {
    var url: String
    var methods: [String]
    var formData: Data

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
        self.formData = Data()
    }

    func handleRequest(method: String, data: Data) -> HTTPResponse {
        switch method {
        case "DELETE": do {
            formData = Data()
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "POST", "PUT": do {
            formData = data
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "GET": do {
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}

class methodOptions: Route {
    var url: String
    var methods: [String]

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
        if method == "OPTIONS" {
            return optionsResponse(methods: methods)
        }
        return   HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
    }
}

class methodOptions2: Route {
    var url: String
    var methods: [String]

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
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
    serverRoutes.addRoute(route: FormRoute(url: "/form",
            methods: ["GET", "POST", "PUT"]))
    serverRoutes.addRoute(route: methodOptions(url: "/method_options",
            methods: ["GET", "HEAD", "POST", "OPTIONS", "PUT"]))
    serverRoutes.addRoute(route: methodOptions2(url: "/method_options2",
            methods: ["GET", "OPTIONS"]))
    return serverRoutes
}
