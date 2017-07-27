import Foundation
import HTTPResponse
import Templates
import Routes

class TeaRoute: Route {
    var url: String
    var methods: [String]
    var formData: Data

    init(url: String, methods: [String]) {
        self.url = url
        self.methods = methods
        self.formData = Data()
    }

    func handleRequest(method: String, data: Data) -> HTTPResponse {
        switch method {
        case "GET": do {
            return CommonResponses.OKResponse
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}