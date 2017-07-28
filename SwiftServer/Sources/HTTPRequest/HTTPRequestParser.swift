import Foundation

enum ParsingErrors: Error {
    case BadRequest
}

public protocol HTTPRequestParse {
    var startLine: RequestLineParse! { get }
    var headers: String? { get }
    var messageBody: String? { get }

}

public class HTTPParsedRequest: HTTPRequestParse {
    public var startLine: RequestLineParse!
    public var headers: String?
    public var messageBody: String?

    public init(request: String) throws {
        let messageParts = try parseHTTPRequest(request: request)
        messageBody = messageParts.messageBody ?? nil
        let headerAndRequestLine = parseHeaderAndRequestLine(
                headerAndMessageRequestLine: messageParts.headerAndRequestLine)
        headers = headerAndRequestLine.headers ?? nil
        startLine = try parseRequestLine(requestLine: headerAndRequestLine.requestLine)
    }

    func parseRequestLine(requestLine: String) throws -> RequestLineParse {
        guard let requestLine = try? RequestLine(requestLine: requestLine) else {
            throw ParsingErrors.BadRequest
        }
        return requestLine
    }

    func parseHTTPRequest(request: String) throws -> (headerAndRequestLine: String, messageBody: String?) {
        if !request.contains("\r\n\r\n") {
            throw ParsingErrors.BadRequest
        }
        let stringArray = request.components(separatedBy: "\r\n\r\n")
        if stringArray.count > 1 {
            return (headerAndRequestLine: stringArray[0], messageBody: stringArray[1])
        }
        return (headerAndRequestLine: stringArray[0], messageBody: nil)
    }

    func parseHeaderAndRequestLine(headerAndMessageRequestLine: String) -> (requestLine: String, headers: String?) {
        var headerArray = headerAndMessageRequestLine.characters
                .split(separator: "\r\n", maxSplits: 1)
                .map(String.init)
        if headerArray.count > 1 {
            return (requestLine: headerArray[0], headers: headerArray[1])
        }
        return (requestLine: headerArray[0], headers: nil)
    }
}
