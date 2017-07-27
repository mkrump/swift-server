import Foundation
import HTTPResponse
import Templates
import Routes

class FormRoute: Route {
    var name: String
    var methods: [String]
    var formData: Data

    init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.formData = Data()
    }

    func handleRequest(method: String, data: Data) -> HTTPResponse {
        switch method {
        case "DELETE": do {
            formData = Data()
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "POST", "PUT": do {
            formData = data
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        case "GET": do {
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse.setMessage(message: Data(form.utf8))
        }
        default:
            return CommonResponses.NotFoundResponse
        }
    }
}
