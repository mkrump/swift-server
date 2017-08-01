import Foundation
import HTTPResponse
import Templates

public class RedirectRoute: Route {
    public var name: String
    public var methods: [String]
    public var newRoute: String

    public init(name: String, newRoute: String) {
        self.name = name
        self.methods = ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "PATCH", "CONNECT"]
        self.newRoute = newRoute
    }

    public func handleRequest(method: String, data: Data = Data(), params: [String: String]? = nil) -> HTTPResponse {
        return CommonResponses.FoundResponse(newLocation: newRoute)
    }
}
