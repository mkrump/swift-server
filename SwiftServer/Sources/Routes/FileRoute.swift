import Foundation
import HTTPResponse
import HTTPRequest
import Templates
import FileSystem

class FileRoute: Route {
    var name: String
    var methods: [String]
    var isDir: ObjCBool
    var eTag: String?
    var mimeType: String!
    var url: String!
    var fileManager: FileSystem

    init(name: String, isDir: ObjCBool, fileManager: FileSystem, fullPath: String, mimeType: String? = nil) {
        self.name = name
        self.methods = ["GET", "HEAD", "PATCH"]
        self.isDir = isDir
        self.fileManager = fileManager
        self.url = fullPath
        self.mimeType = setContentType(contentType: mimeType)
    }

    private func fileToMessage(isDir: ObjCBool, fileManager: FileSystem, url: String, range: Range<Int> = 0..<0) -> Data {
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

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
        if let currentEtag = generateEtag(content: content) {
            eTag = currentEtag
        }
        if !eTagValid(currentEtag: eTag, headers: request.headers) {
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.PRECONDITION_FAILED)
        }
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
        if method == "PATCH" {
            if let patchData = request.messageBody {

                let data = Data(patchData.utf8)
                let fileURL = URL(fileURLWithPath: self.url)
                try? data.write(to: fileURL)
            }
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.NO_CONTENT)
        }

        return CommonResponses.OKResponse()
                .addHeader(key: "Content-Type", value: self.mimeType)
                .setMessage(message: content)
    }
}
