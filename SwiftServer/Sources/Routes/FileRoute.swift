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

    public func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, url: String, range: Range<Int> = 0..<0) -> Data {
        if isDir.boolValue {
            guard let dir = try? fileManager.contentsOfDirectory(atPath: url) else {
                return Data()
            }
            return Data(dirListing(target: url, directories: dir).utf8)
        } else if !range.isEmpty {
            return fileManager.partialContents(atPath: url, range: range)!
        } else if let file = fileManager.contents(atPath: url) {
            return file
        }
        return Data()
    }

    func parseRange(byteRange: String) -> Range<Int>? {
        var rangeArray = byteRange.components(separatedBy: "=")[1].components(separatedBy: "-").map {
            Int($0)
        }
        guard let fileSize = fileManager.fileSize(atPath: url) else {
            return nil
        }
        switch (rangeArray[0], rangeArray[1]) {
        case let (.some(lb), .some(ub)):
            let adjUb = min(ub + 1, fileSize)
            return lb..<adjUb
        case let (.some(lb), nil):
            return lb..<fileSize
        case let (nil, .some(ub)):
            let lb = fileSize - ub
            return lb..<fileSize
        default:
            return nil
        }
    }

    func isRangeRequest(headers: HeaderParse?) -> String? {
        if let headers = headers,
           let headerDict = headers.headerDict,
           let range = headerDict["Range"] {
            return range
        }
        return nil
    }

    open func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
        if method == "OPTIONS" {
            return CommonResponses.OptionsResponse(methods: methods)
        }
        if let range = isRangeRequest(headers: request.headers) {
            if let byteRange = parseRange(byteRange: range) {
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
