import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import FileSystem

open class FileRoute: Route {
    public var name: String
    public var methods: [String]
    public var isDir: ObjCBool
    public var eTag: String?
    public var mimeType: String!
    public var url: String!
    public var fileManager: FileSystem

    public init(name: String, methods: [String] = ["GET", "HEAD"], isDir: ObjCBool, fileManager: FileSystem, fullPath: String, mimeType: String? = nil) {
        self.name = name
        self.methods = methods
        self.isDir = isDir
        self.fileManager = fileManager
        self.url = fullPath
        self.mimeType = setContentType(contentType: mimeType)
    }

    open func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        if let range = isRangeRequest(headers: request.headers) {
            let fileSize = fileManager.fileSize(atPath: url)
            if let byteRange = parseRange(byteRange: range, fileSize: fileSize) {
                let content = fileToMessage(isDir: isDir, fileManager: fileManager, url: url, range: byteRange)
                return CommonResponses.PartialContentResponse()
                        .addHeader(key: "Content-Type", value: self.mimeType)
                        .setMessage(message: content)
            } else {
                return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.RANGE_NOT_SATISFIABLE)
            }
        }

        return CommonResponses.OKResponse()
                .addHeader(key: "Content-Type", value: self.mimeType)
                .setMessage(message: content)
    }
}
