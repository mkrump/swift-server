import Foundation
import HTTPResponse
import Templates
import Routes

class RedirectRoute: Route {
    var name: String
    var methods: [String]
    var newRoute: String

    init(name: String, newRoute: String) {
        self.name = name
        self.methods = ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "PATCH", "CONNECT"]
        self.newRoute = newRoute
    }

    func handleRequest(method: String, data: Data = Data(), params: [String: String]? = nil) -> HTTPResponse {
        return CommonResponses.FoundResponse(newLocation: newRoute)
    }
}
