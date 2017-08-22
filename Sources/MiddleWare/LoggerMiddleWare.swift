import SimpleURL
import FileSystem
import HTTPRequest
import Foundation

public class LoggerMiddleware: Invokable {
    var logger: Logger?

    public init(logPath: simpleURL) {
            self.logger =  try? Logger(url: logPath)
    }

    private func logRequest(parsedRequest: HTTPRequestParse) {
        if let logger = self.logger {
            let date = Date().dateToRFC822String()
            let request = parsedRequest.requestLine.rawRequestLine
            let logLine = "[\(date)] \(request)"
            logger.appendLog(contents: logLine)
        }
    }

    public func invoke(request: HTTPRequestParse, url: simpleURL, fileManager: FileSystem) ->
            MiddlewareResponse {
        logRequest(parsedRequest: request)
        return MiddlewareResponse(response: nil, request: request)
    }
}