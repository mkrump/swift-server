import Foundation
import Socket
import HTTPRequest

protocol ServerRequestParsing {
    func parseRequest(request: String) throws -> HTTPRequestParse
}

struct ServerRequestParser: ServerRequestParsing {
    public init() {}

    public func parseRequest(request: String) throws -> HTTPRequestParse {
        var headers: HeaderParse? = nil
        guard let messageParts = try? parseHTTPRequest(request: request) else {
            throw ServerErrors.badRequest
        }
        let messageBody = buildMessageBody(messageParts: messageParts)
        let headerAndRequestLine = parseHeaderAndRequestLine(headerAndMessageRequestLine: messageParts.headerAndRequestLine)
        if let headerLine = headerAndRequestLine.headers {
            headers = buildHeader(headerLine: headerLine)
        }
        guard let requestLine = try? parseRequestLine(requestLine: headerAndRequestLine.requestLine) else {
            throw ServerErrors.badRequest
        }
        return HTTPParsedRequest(requestLine: requestLine, headers: headers, messageBody: messageBody)
    }

    private func buildHeader(headerLine: String) -> HeaderParse? {
        if let headerDict = parseHeaders(headers: headerLine) {
            return HTTPHeader(rawHeaders: headerLine, headerDict: headerDict)
        }
        return nil
    }

    private func buildMessageBody(messageParts: (_: String, messageBody: String?)) -> String? {
        if let parsedMessageBody = messageParts.messageBody {
            return parsedMessageBody
        }
        return nil
    }
}


