import SimpleURL
import FileSystem
import HTTPRequest
import HTTPResponse
import Foundation

public protocol Invokable {
    func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) ->
            MiddlewareResponse
}

public struct MiddlewareResponse {
    public var response: HTTPResponse?
    public var request: HTTPRequestParse
}

public struct Middleware {
    public var invokable: Invokable
    public var routeName: String?

    public func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> MiddlewareResponse {
        return invokable.invoke(request: request, url: url, fileManager: fileManager)
    }
}

public class MiddlewareExecutor {
    var middleWares: [Middleware] = []

    public func addMiddleWare(middleWare: Invokable) {
        middleWares.append(Middleware(invokable: middleWare, routeName: nil))
    }

    public func addMiddleWare(middleWare: Invokable, route: String) {
        middleWares.append(Middleware(invokable: middleWare, routeName: route))
    }

    public init() {
    }

    public func execute(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) -> MiddlewareResponse {
        var next = MiddlewareResponse(response: nil, request: request)
        for middleWare in middleWares {
            next = generateNext(middleWare: middleWare, url: url, fileManager: fileManager, next: next)
            if next.response != nil {
                return next
            }
        }
        return next
    }

    private func generateNext(middleWare: Middleware, url: simpleURL, fileManager: FileSystem, next: MiddlewareResponse)
                    -> MiddlewareResponse {
        if middleWare.routeName == nil {
            return middleWare.invoke(request: next.request, url: url, fileManager: fileManager)
        } else if url.baseName == middleWare.routeName {
            return middleWare.invoke(request: next.request, url: url, fileManager: fileManager)
        }
        return next
    }
}
