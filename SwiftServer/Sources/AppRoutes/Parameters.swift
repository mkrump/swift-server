import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class ParametersRoute: Route {
    var name: String
    var methods: [String]

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let params = request.requestLine.params
        if let paramsUnwrapped = params {
            let html = echoParams(params: paramsUnwrapped)
            return CommonResponses.OKResponse().setMessage(message: Data(html.utf8))
        } else {
            return CommonResponses.OKResponse()
        }
    }
}
