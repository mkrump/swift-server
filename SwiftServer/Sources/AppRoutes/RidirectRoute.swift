import Foundation
import HTTPResponse
import Templates
import Routes

class RedirectRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(method: String, data: Data, params: [String: String]? = nil) -> HTTPResponse {
        return CommonResponses.FoundResponse(newLocation: "/")
    }
}
