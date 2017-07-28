import Foundation
import HTTPRequest
import HTTPResponse
import FileSystem
import Routes

struct MockRoute: Route {
    var name: String
    var methods: [String] = []
    var requestHandler: (String, Data) -> HTTPResponse

    func handleRequest(method: String, data: Data = Data(), params: [String: String]? = nil) -> HTTPResponse {
        return requestHandler(method, data)
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

public class MockHTTParsedRequest: HTTPRequestParse {
    public var startLine: RequestLineParse!
    public var headers: String?
    public var messageBody: String?

    init(startLine: RequestLineParse, headers: String? = nil, messageBody: String? = nil) {
        self.headers = headers
        self.messageBody = messageBody
        self.startLine = startLine
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