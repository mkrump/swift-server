import Foundation
import HTTPRequest
import HTTPResponse
import FileSystem
import Routes

public struct MockRoute: Route {
    public var name: String
    public var methods: [String] = []
    public var requestHandler: (HTTPRequestParse) -> HTTPResponse

    public init(name: String, methods: [String], requestHandler: @escaping (HTTPRequestParse) -> HTTPResponse) {
        self.name = name
        self.methods = methods
        self.requestHandler = requestHandler
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        return requestHandler(request)
    }
}

public class MockHeaders: HeaderParse {
    public var rawHeaders: String?
    public var headerDict: [String: String]?

    public init(rawHeaders: String, headerDict: [String: String]) {
        self.rawHeaders = rawHeaders
        self.headerDict = headerDict
    }
}

public class MockRequestLine: RequestLineParse {
    public var httpMethod: String!
    public var target: String!
    public var params: [String: String]?
    public var httpVersion: String!
    public private(set) var rawRequestLine: String = ""

    public init(httpMethod: String, target: String, httpVersion: String) {
        self.httpMethod = httpMethod
        self.target = target
        self.httpVersion = httpVersion
    }

}

public class MockHTTParsedRequest: HTTPRequestParse {
    public var requestLine: RequestLineParse
    public var headers: HeaderParse?
    public var headerDict: [String: String]?
    public var messageBody: String?

    public init(startLine: RequestLineParse, headers: HeaderParse? = nil,
                headerDict: [String: String]? = nil, messageBody: String? = nil) {
        self.headers = headers
        self.headerDict = headerDict
        self.messageBody = messageBody
        self.requestLine = startLine
    }

}

public class MockIsRoute: FileSystem {
    public init() {
    }

    public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return false
    }

    public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return []
    }

    public func contents(atPath path: String) -> Data? {
        return nil
    }

    public func partialContents(atPath path: String, range: Range<Int>) -> Data? {
        return nil
    }

    public func fileSize(atPath path: String) -> Int? {
        return nil
    }

    public func currentDirectoryPath() -> String {
        return "./"
    }
}

public class MockIsFile: MockIsRoute {
    public override init() {
    }

    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = false
        }
        return true
    }

    override public func contentsOfDirectory(atPath path: String) throws -> [String] {
        return ["dir1", "dir2"]
    }

    override public func contents(atPath path: String) -> Data? {
        return Data("Hi!".utf8)
    }
}

public class MockIsDir: MockIsRoute {
    public override init() {
    }

    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = true
        }
        return true
    }
}
