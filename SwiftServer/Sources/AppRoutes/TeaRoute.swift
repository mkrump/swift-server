import Foundation
import HTTPResponse
import HTTPRequest
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

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
            return CommonResponses.OKResponse()
        }
}
