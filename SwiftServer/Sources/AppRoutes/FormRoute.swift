import Foundation
import HTTPResponse
import Templates
import Routes

class FormRoute: Route {
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
        case "DELETE": do {
            formData = Data()
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "POST", "PUT": do {
            formData = data
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "GET": do {
            let form = generateForm(target: self.url, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}
