import Foundation
import HTTPResponse
import HTTPRequest
import FileSystem
import Templates
import Routes

class PatchRoute: FileRoute {
    init(name: String, methods: [String], path: String, fileManager: FileSystem) {
        super.init(url: simpleURL(path: path, baseName: name), methods: methods, isDir: ObjCBool(false), fileManager: fileManager)
    }

    override func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
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
