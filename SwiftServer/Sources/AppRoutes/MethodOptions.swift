import Foundation
import HTTPResponse
import Templates
import Routes

class MethodOptions: Route {
    var url: String
    var methods: [String]

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        return CommonResponses.OKResponse
    }
}
