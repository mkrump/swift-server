public func parseRange(byteRange: String, fileSize: Int?) -> Range<Int>? {
    var rangeArray = byteRange.components(separatedBy: "=")[1].components(separatedBy: "-").map {
        Int($0)
    }
    guard let fileSize = fileSize else {
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

public func isRangeRequest(headers: HeaderParse?) -> String? {
    if let headers = headers,
       let headerDict = headers.headerDict,
       let range = headerDict["Range"] {
        return range
    }
    return nil
}