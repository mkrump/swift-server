import Foundation
import HTTPResponse
import SimpleURL
import HTTPRequest
import FileSystem
import Templates
import Routes

public class PatchRoute: NonVirtual {

    public var name: String
    public var methods: [String]
    public var isDir: Bool
    public var eTag: String?
    public var mimeType: String!
    public var url: simpleURL!
    public var fileManager: FileSystem

    public required init(name: String, methods: [String], url: simpleURL, fileManager: FileSystem, isDir: Bool? = nil, mimeType: String?) {
        self.name = url.baseName
        self.methods = methods
        self.isDir = false
        self.fileManager = fileManager
        self.url = url
        self.mimeType = setContentType(contentType: mimeType)
    }

    public func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
        let method = request.requestLine.httpMethod
        let content = fileToMessage(isDir: isDir, fileManager: fileManager, url: url)
        if let currentEtag = generateEtag(content: content) {
            eTag = currentEtag
        }
        if !eTagValid(currentEtag: eTag, headers: request.headers) {
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.PRECONDITION_FAILED)
        }
        if method == "PATCH" {
            if let patchData = request.messageBody {
                let data = Data(patchData.utf8)
                let fileURL = URL(fileURLWithPath: self.url.fullName)
                try? data.write(to: fileURL)
            }
            return CommonResponses.DefaultHeaders(responseCode: ResponseCodes.NO_CONTENT)
        }
        return CommonResponses.OKResponse()
                .addHeader(key: "Content-Type", value: self.mimeType)
                .setMessage(message: content)
    }
}
