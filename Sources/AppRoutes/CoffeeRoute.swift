import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class CoffeeRoute: Route {
    public var name: String
    public var methods: [String]
    var formData: Data

    public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.formData = Data()
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        return CommonResponses
                .DefaultHeaders(responseCode: ResponseCodes.IM_A_TEAPOT)
                .setMessage(message: Data(basicTemplate(message: "I'm a teapot").utf8))
    }
}
