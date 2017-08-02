import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class TeaRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
            return CommonResponses.OKResponse()
        }
}
