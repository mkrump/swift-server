import Foundation
public struct ResponseCodes {
    public static let OK = (code: 200, message: "OK")
    public static let NOT_FOUND = (code: 404, message: "Not Found")
    public static let BAD_REQUEST = (code: 400, message: "Bad Request")
    public static let MOVED_PERMANENTLY = (code: 301, message: "Moved Permanently")
    public static let FOUND = (code: 302, message: "Found")
}
