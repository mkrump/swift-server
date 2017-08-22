import Foundation

enum ParsingErrors: Error {
    case BadRequest
}

public protocol HTTPRequestParse {
    var requestLine: RequestLineParse { get }
    var headers: HeaderParse? { get }
    var messageBody: String? { get }

}

public func parseRequestLine(requestLine: String) throws -> RequestLineParse {
    guard let requestLine = try? RequestLine(requestLine: requestLine) else {
        throw ParsingErrors.BadRequest
    }
    return requestLine
}

public func parseHTTPRequest(request: String) throws -> (headerAndRequestLine: String, messageBody: String?) {
    if !request.contains("\r\n\r\n") {
        throw ParsingErrors.BadRequest
    }
    let stringArray = request.components(separatedBy: "\r\n\r\n")
    if stringArray.count > 1 {
        return (headerAndRequestLine: stringArray[0], messageBody: stringArray[1])
    }
    return (headerAndRequestLine: stringArray[0], messageBody: nil)
}

public func parseHeaderAndRequestLine(headerAndMessageRequestLine: String) -> (requestLine: String, headers: String?) {
    var headerArray = headerAndMessageRequestLine.characters
            .split(separator: "\r\n", maxSplits: 1)
            .map(String.init)
    if headerArray.count > 1 {
        return (requestLine: headerArray[0], headers: headerArray[1])
    }
    return (requestLine: headerArray[0], headers: nil)
}

public struct HTTPParsedRequest: HTTPRequestParse {
    public var requestLine: RequestLineParse
    public var headers: HeaderParse?
    public var messageBody: String?

    public init(requestLine: RequestLineParse, headers: HeaderParse? = nil, messageBody: String? = nil) {
        self.messageBody = messageBody
        self.headers = headers
        self.requestLine = requestLine
    }
}
