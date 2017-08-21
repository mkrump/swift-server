import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class CookieRoute: Virtual {
    public var name: String
    public var methods: [String]

    required public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
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
