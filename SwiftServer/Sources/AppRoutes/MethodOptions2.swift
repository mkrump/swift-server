import Foundation
import HTTPResponse
import Templates
import Routes

class MethodOptions2: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(method: String, data: Data = Data()) -> HTTPResponse {
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        return CommonResponses.OKResponse
    }
}
