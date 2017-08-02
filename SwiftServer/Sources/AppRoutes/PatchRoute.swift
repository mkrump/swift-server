import Foundation
import HTTPResponse
import HTTPRequest
import FileSystem
import Templates
import Routes

class PatchRoute: Route {
    public var name: String
    public var methods: [String]
    public var isDir: ObjCBool
    public var eTag: String?
    public var mimeType: String!
    public var fullPath: String!
    public var fileManager: FileSystem

    public init(url: simpleURL, methods: [String], fileManager: FileSystem, mimeType: String? = nil) {
        self.name = url.baseName
        self.methods = methods
        self.isDir = ObjCBool(false)
        self.fileManager = fileManager
        self.fullPath = url.fullName
        self.mimeType = setContentType(contentType: mimeType)
    }

    func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, fullPath: fullPath)
        if let currentEtag = generateEtag(content: content) {
            eTag = currentEtag
        }
        if !eTagValid(currentEtag: eTag, headers: request.headers) {
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.PRECONDITION_FAILED)
        }
        if method == "PATCH" {
            if let patchData = request.messageBody {
                let data = Data(patchData.utf8)
                let fileURL = URL(fileURLWithPath: self.fullPath)
                try? data.write(to: fileURL)
            }
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.NO_CONTENT)
        }
        return CommonResponses.OKResponse()
                .addHeader(key: "Content-Type", value: self.mimeType)
                .setMessage(message: content)
    }
}
