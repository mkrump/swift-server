import Foundation
import HTTPRequest
import HTTPResponse
import FileSystem
import Routes

struct MockRoute: Route {
    var name: String
    var methods: [String] = []
    var requestHandler: (HTTPRequestParse) -> HTTPResponse

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        return requestHandler(request)
    }
}

public class MockRequestLine: RequestLineParse {
    public var httpMethod: String!
    public var target: String!
    public var params: [String: String]?
    public var httpVersion: String!

    init(httpMethod: String, target: String, httpVersion: String) {
        self.httpMethod = httpMethod
        self.target = target
        self.httpVersion = httpVersion
    }
}

public class MockHeaders: HeaderParse {
    public var rawHeaders: String?
    public var headerDict: [String: String]?

    init(rawHeaders: String, headerDict: [String: String]) {
        self.rawHeaders = rawHeaders
        self.headerDict = headerDict
    }
}

public class MockHTTParsedRequest: HTTPRequestParse {
    public var requestLine: RequestLineParse!
    public var headers: HeaderParse?
    public var headerDict: [String: String]?
    public var messageBody: String?

    init(startLine: RequestLineParse, headers: HeaderParse? = nil,
         headerDict: [String: String]? = nil, messageBody: String? = nil) {
        self.headers = headers
        self.headerDict = headerDict
        self.messageBody = messageBody
        self.requestLine = startLine
    }

}

public class MockIsRoute: FileSystem {
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
}

public class MockIsFile: MockIsRoute {

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
    override public func fileExists(atPath path: String, isDirectory: UnsafeMutablePointer<ObjCBool>?) -> Bool {
        if let isDir = isDirectory {
            isDir.pointee = true
        }
        return true
    }
}
