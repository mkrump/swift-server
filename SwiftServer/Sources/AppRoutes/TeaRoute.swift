import Foundation
import HTTPResponse
import Templates
import Routes

class TeaRoute: Route {
    var name: String
    var methods: [String]
    var formData: Data

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.formData = Data()
    }

    func handleRequest(method: String, data: Data, params: [String: String]? = nil) -> HTTPResponse {
        switch method {
        case "GET": do {
            return CommonResponses.OKResponse
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}