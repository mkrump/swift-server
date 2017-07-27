import Foundation
import HTTPResponse
import Templates
import Routes

class ParametersRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(method: String, data: Data, params: [String: String]? = nil) -> HTTPResponse {
        if let paramsUnwrapped = params {
            let html = echoParams(params: paramsUnwrapped)
            return CommonResponses.OKResponse.setMessage(message: Data(html.utf8))
        } else {
            return CommonResponses.OKResponse
        }
    }
}
