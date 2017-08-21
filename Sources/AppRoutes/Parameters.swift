import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class ParametersRoute: Virtual {
    public var name: String
    public var methods: [String]

    required public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let params = request.requestLine.params
        if let paramsUnwrapped = params {
            let html = echoParams(params: paramsUnwrapped)
            return CommonResponses.OKResponse().setMessage(message: Data(html.utf8))
        } else {
            return CommonResponses.OKResponse()
        }
    }
}
