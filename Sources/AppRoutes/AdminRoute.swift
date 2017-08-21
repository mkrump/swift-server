import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class AdminRoute: Virtual {
    public var name: String
    public var methods: [String]

    required public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        return CommonResponses.OKResponse().setMessage(message: Data("Hi!".utf8))
    }
}
