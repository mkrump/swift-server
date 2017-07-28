public let contentTypes = [
    "txt": "text/plain",
    "html": "text/html",
    "jpeg": "image/jpeg",
    "png": "image/png",
    "gif": "image/gif"
]

public func inferContentType(fileName: String) -> String {
    guard let contentType = fileName.components(separatedBy: ".").last else {
        return contentTypes["html"]!
    }
    guard let mimeType = contentTypes[contentType] else {
        return contentTypes["html"]!
    }
    return mimeType
}