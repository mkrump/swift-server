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
    public var fullPath: String!
    public var fileManager: FileSystem

    public init(url: simpleURL, methods: [String] = ["GET", "HEAD"], isDir: ObjCBool, fileManager: FileSystem, mimeType: String? = nil) {
        self.name = url.baseName
        self.methods = methods
        self.isDir = isDir
        self.fileManager = fileManager
        self.fullPath = url.fullName
        self.mimeType = setContentType(contentType: mimeType)
    }

    open func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, fullPath: fullPath)
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        if let range = isRangeRequest(headers: request.headers) {
            let fileSize = fileManager.fileSize(atPath: fullPath)
            if let byteRange = parseRange(byteRange: range, fileSize: fileSize) {
                let content = fileToMessage(isDir: isDir, fileManager: fileManager, fullPath: fullPath, range: byteRange)
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
