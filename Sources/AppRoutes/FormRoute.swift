import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import Routes

public class FormRoute: Virtual {
    public var name: String
    public var methods: [String]
    var formData: Data

    required public init(name: String, methods: [String]) {
        self.name = name
        self.methods = methods
        self.formData = Data()
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod!
        switch method {
        case "DELETE": do {
            formData = Data()
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse().setMessage(message: Data(form.utf8))
        }
        case "POST", "PUT": do {
            formData = Data(request.messageBody!.utf8)
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse().setMessage(message: Data(form.utf8))
        }
        case "GET": do {
            let form = generateForm(target: self.name, data: formData)
            return CommonResponses.OKResponse().setMessage(message: Data(form.utf8))
        }
        default:
            return CommonResponses.NotFoundResponse()
        }
    }
}
