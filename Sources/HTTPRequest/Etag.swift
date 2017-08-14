import Foundation
import CryptoSwift

public func eTagValid(currentEtag: String?, headers: HeaderParse?) -> Bool {
    if let headers = headers,
       let headerDict = headers.headerDict,
       let newEtag = headerDict["If-Match"],
       let currentEtag = currentEtag {
        return currentEtag == newEtag
    }
    return true
}

public func generateEtag(content: Data) -> String? {
    return content.sha1().toHexString()
}