import Foundation
import HTTPResponse

public protocol Route {
    var url: String { get }
    var methods: [String] { get }
    mutating func handleRequest(method: String, data: Data) -> HTTPResponse
}
