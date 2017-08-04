import Foundation
public struct ResponseCodes {
    public static let OK = (code: 200, message: "OK")
    public static let PARTIAL_CONTENT = (code: 206, message: "Partial Content")
    public static let NO_CONTENT = (code: 204, message: "No Content")
    public static let BAD_REQUEST = (code: 400, message: "Bad Request")
    public static let UNAUTHORIZED = (code: 401, message: "Unauthorized")
    public static let NOT_FOUND = (code: 404, message: "Not Found")
    public static let METHOD_NOT_ALLOWED = (code: 405, message: "Method Not Allowed")
    public static let RANGE_NOT_SATISFIABLE = (code: 406, message: "Range Not Satisfiable")
    public static let PRECONDITION_FAILED = (code: 412, message: "Precondition Failed")
    public static let IM_A_TEAPOT = (code: 418, message: "I'm a teapot")
    public static let MOVED_PERMANENTLY = (code: 301, message: "Moved Permanently")
    public static let FOUND = (code: 302, message: "Found")
}
