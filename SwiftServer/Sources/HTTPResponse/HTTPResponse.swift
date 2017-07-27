import Foundation

class Header {
    var key: String
    var value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    func formatMessage() -> String {
        return key + ": " + value
    }

}

public class HTTPResponse {
    public var version: String?
    public var responseCode: (code: Int, message: String)?
    public var message: Data?
    var headers: [Header]
    var crlf: String
    var space: String

    public init() {
        self.crlf = "\r\n"
        self.space = " "
        self.headers = []
    }

    public func setVersion(version: Double) -> HTTPResponse {
        switch version {
        case 1.1: self.version = "HTTP/1.1"
        case 1.0: self.version = "HTTP/1.0"
        default: self.version = "HTTP/0.9"
        }
        return self
    }

    public func setResponseCode(responseCode: (code: Int, message: String)) -> HTTPResponse {
        self.responseCode = (code: responseCode.code, message: responseCode.message)
        return self
    }

    public func addHeader(key: String, value: String) -> HTTPResponse {
        let header = Header(key: key, value: value)
        self.headers.append(header)
        return self
    }

    public func setMessage(message: Data) -> HTTPResponse {
        self.message = message
        return self
    }

    func generateHeaders(headerArray: [Header]) -> String {
        if headerArray.isEmpty {
            return ""
        }
        let headerArray = headerArray.map {
            $0.formatMessage()
        }
        return headerArray.joined(separator: crlf) + crlf
    }

    public func generateResponse() -> Data {
        guard let version = self.version,
              let responseStatusCode: Int = self.responseCode?.code,
              let responseStatusCodeMessage = self.responseCode?.message
                else {
            return Data()
        }
        let message = self.message ?? Data()
        let headers = self.generateHeaders(headerArray: self.headers)
        let responseText = version + space + String(responseStatusCode) + space + responseStatusCodeMessage + crlf +
                headers +
                crlf
        var headerData = Data(responseText.utf8)
        headerData.append(message)
        return headerData
    }

}
