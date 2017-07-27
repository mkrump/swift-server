import Foundation
import HTTPResponse

public protocol Route {
    var name: String { get }
    var methods: [String] { get }
    mutating func handleRequest(method: String, data: Data, params: [String: String]?) -> HTTPResponse
}

public extension Route {
    func methodAllowed(method: String) -> Bool {
        if methods.contains(method) {
            return true
        }
        return false
    }
}
