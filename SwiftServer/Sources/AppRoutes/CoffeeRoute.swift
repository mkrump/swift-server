import Foundation
import HTTPResponse
import Templates
import Routes

class CoffeeRoute: Route {
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
            return HTTPResponse()
                    .setVersion(version: 1.1)
                    .setResponseCode(responseCode: ResponseCodes.IM_A_TEAPOT)
                    .setMessage(message: Data(imATeapot().utf8))
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}