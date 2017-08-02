import Foundation
import HTTPResponse
import HTTPRequest
import FileSystem
import Templates
import Routes

class PatchRoute: FileRoute {
    init(name: String, methods: [String], path: String) {
        super.init(name: name, isDir: ObjCBool(false), methods: methods, fileManager: ServerFileManager(), fullPath: path + name)
    }

    override func handleRequest(request: HTTPRequestParse) -> HTTPResponse {
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
