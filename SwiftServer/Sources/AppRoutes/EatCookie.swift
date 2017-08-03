import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class EatCookieRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        if let headers = request.headers,
           let headerDict = headers.headerDict,
           let cookieType = headerDict["Cookie"] {
            return CommonResponses.OKResponse()
                    .setMessage(message: Data(basicTemplate(message: "mmmm \(cookieType)").utf8))
        } else {
            return CommonResponses.OKResponse()
        }
    }
}