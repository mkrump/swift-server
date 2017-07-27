import Foundation
import HTTPResponse
import Templates
import Routes

class RootRoute: Route {
    var url: String
    var methods: [String]

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
        return CommonResponses.OKResponse.setMessage(message: Data("Hello!".utf8))
    }
}
