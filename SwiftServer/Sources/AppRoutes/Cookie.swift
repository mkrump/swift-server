import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class CookieRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let params = request.requestLine.params
        if let params = params,
           let cookieType = params["type"] {
            return CommonResponses.OKResponse()
                    .addHeader(key: "Set-Cookie", value: cookieType)
                    .setMessage(message: Data("Eat \(cookieType)".utf8))
        } else {
            return CommonResponses.OKResponse()
        }
    }
}
