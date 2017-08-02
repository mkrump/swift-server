import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

class CoffeeRoute: Route {
    var name: String
    var methods: [String]
    var formData: Data

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.formData = Data()
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
            return HTTPResponse()
                    .setVersion(version: 1.1)
                    .setResponseCode(responseCode: ResponseCodes.IM_A_TEAPOT)
                    .setMessage(message: Data(imATeapot().utf8))
        }
}
