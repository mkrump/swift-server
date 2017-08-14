public protocol RequestLineParse {
    var httpMethod: String! { get }
    var target: String! { get }
    var params: [String: String]? { get }
    var httpVersion: String! { get }
    var rawRequestLine: String {get}
}

extension Dictionary {
    init(elements: [(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}

public class RequestLine: RequestLineParse {
    public var httpMethod: String!
    public var target: String!
    public var params: [String: String]?
    public var httpVersion: String!
    public var rawRequestLine: String

    init(requestLine: String) throws {
        rawRequestLine = requestLine
        var requestLineArray = requestLine.components(separatedBy: " ")
        if requestLineArray.count != 3 {
            throw ParsingErrors.BadRequest
        }
        httpMethod = requestLineArray[0]
        httpVersion = requestLineArray[2]
        let parsedTarget = parseTarget(target: requestLineArray[1])
        target = parsedTarget.target
        params = parsedTarget.params
    }

    func parseTarget(target: String) -> (target: String, params: [String: String]?) {
        var targetArray = target.characters
                .split(separator: "?", maxSplits: 1)
                .map(String.init)
        if targetArray.count == 2 {
            let paramsArray = targetArray[1].components(separatedBy: "&")
            let parsedParams = Dictionary(elements: paramsArray
                    .map({ $0.components(separatedBy: "=") })
                    .map({ ($0[0].removingPercentEncoding!, $0[1].removingPercentEncoding!) })
            )
            return (target: targetArray[0], params: parsedParams)
        }
        return (target: targetArray[0], params: nil)
    }
}
