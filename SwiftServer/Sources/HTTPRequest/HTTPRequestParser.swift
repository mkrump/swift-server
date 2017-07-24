import Foundation

enum ParsingErrors: Error {
    case BadRequest
}

public class RequestLine {
    public var httpMethod: String
    public var target: String
    public var httpVersion: String

    init(requestLine: String) throws {
        var requestLineArray = requestLine.components(separatedBy: " ")
        if requestLineArray.count != 3 {
            throw ParsingErrors.BadRequest
        }
        httpMethod = requestLineArray[0]
        target = requestLineArray[1]
        httpVersion = requestLineArray[2]
    }
}

public class HTTPRequestParser {
    public var startLine: RequestLine!
    public var headers: String?
    public var messageBody: String?

    public init(request: String) throws {
        try parseHTTPRequest(request: request)
    }

    func parseHTTPRequest(request: String) throws {
        if !request.contains("\r\n\r\n") {
            throw ParsingErrors.BadRequest
        }
        let stringArray = request.components(separatedBy: "\r\n\r\n")
        let nonMessageBody = stringArray[0]
        try parseHeaders(nonMessageBody: nonMessageBody)
        if stringArray.count > 1 {
            messageBody = stringArray[1]
        }
    }

    func parseHeaders(nonMessageBody: String) throws {
        var headerArray = nonMessageBody.characters.split(separator: "\r\n", maxSplits: 1).map(String.init)
        startLine = try RequestLine(requestLine: headerArray[0])
        if headerArray.count > 1 {
            headers = headerArray[1]
        }
    }
}
