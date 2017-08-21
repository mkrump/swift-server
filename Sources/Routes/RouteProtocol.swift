import Foundation
import HTTPRequest
import HTTPResponse
import SimpleURL
import FileSystem

public protocol Route {
    var name: String { get }
    var methods: [String] { get }
    mutating func handleRequest(request: HTTPRequestParse) -> HTTPResponse
}

public protocol Virtual: Route {
    init(name: String, methods: [String])
}

public protocol Redirect: Route {
    init(name: String, newRoute: String)
}

public protocol NonVirtual: Route {
    init(name: String, methods: [String], url: simpleURL, fileManager: FileSystem, isDir: Bool?, mimeType: String?)
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
