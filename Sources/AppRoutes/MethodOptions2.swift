import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class MethodOptions2: Route {
    public var name: String
    public var methods: [String]

    public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        return CommonResponses.OKResponse()
    }
}
