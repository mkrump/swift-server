public protocol RequestLineParse {
    var httpMethod: String { get }
    var target: String { get }
    var httpVersion: String { get }
}

public class RequestLine: RequestLineParse {
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