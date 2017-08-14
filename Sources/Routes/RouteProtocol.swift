import Foundation
import HTTPRequest
import HTTPResponse

public protocol Route {
    var name: String { get }
    var methods: [String] { get }
    mutating func handleRequest(request: HTTPRequestParse) -> HTTPResponse
}

public extension Route {
    func methodAllowed(method: String) -> Bool {
        if methods.contains(method) {
            return true
        }
        return false
    }

    func setContentType(contentType: String?) -> String {
        if let routeContentType = contentType {
            return routeContentType
        } else {
            return inferContentType(fileName: name)
        }
    }
}
