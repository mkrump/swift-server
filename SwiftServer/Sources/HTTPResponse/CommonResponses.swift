public struct CommonResponses {
//    TODO paramaterize this
    public static func DefaultHeaders(responseCode: (code: Int, message: String)) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: responseCode)
    }

    public static func OKResponse() -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.OK)
    }

    public static func NotFoundResponse() -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.NOT_FOUND)
    }

    public static func badRequestResponse() -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.BAD_REQUEST)
    }

    public static func FoundResponse(newLocation: String) -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.FOUND)
                .addHeader(key: "Location", value: newLocation)
    }

    public static func MovedPermanentlyResponse(newLocation: String) -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.MOVED_PERMANENTLY)
                .addHeader(key: "Location", value: newLocation)
    }

    public static func OptionsResponse(methods: [String]) -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.OK)
                .addHeader(key: "Allow", value: methods.joined(separator: ","))
    }

    public static func MethodNotAllowedResponse(methods: [String]) -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.METHOD_NOT_ALLOWED)
                .addHeader(key: "Allow", value: methods.joined(separator: ","))
    }

    public static func PartialContentResponse() -> HTTPResponse {
        return DefaultHeaders(responseCode: ResponseCodes.PARTIAL_CONTENT)
    }
}
