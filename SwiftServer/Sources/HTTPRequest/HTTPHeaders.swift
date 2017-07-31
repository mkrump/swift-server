import Foundation

public protocol HeaderParse {
    var rawHeaders: String? { get }
    var headerDict: [String: String]? { get }
}

public class HTTPHeader: HeaderParse {
    public var rawHeaders: String?
    public var headerDict: [String: String]?

    public init(headerLine: String?) {
        if let headers = headerLine {
            rawHeaders = headers
            headerDict = parseHeaders(headers: headers)
        } else {
            rawHeaders = nil
            headerDict = nil
        }
    }

    public func parseHeaders(headers: String) -> [String: String]? {
        let headerArray = headers.components(separatedBy: "\r\n")
        let parsedHeaders = Dictionary(elements: headerArray
                .map({ $0.components(separatedBy: ": ") })
                .map({ ($0[0], $0[1]) })
        )
        return parsedHeaders
    }
}
