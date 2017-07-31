public struct CommonResponses {
    public static func DefaultHeaders() -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
    }

    public static func OKResponse() -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.OK)
    }

    public static func NotFoundResponse() -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.NOT_FOUND)
    }

    public static func badRequestResponse() -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.BAD_REQUEST)
    }

    public static func FoundResponse(newLocation: String) -> HTTPResponse {
        return DefaultHeaders()
                .addHeader(key: "Location", value: newLocation)
                .setResponseCode(responseCode: ResponseCodes.FOUND)
    }

    public static func MovedPermanentlyResponse(newLocation: String) -> HTTPResponse {
        return DefaultHeaders()
                .addHeader(key: "Location", value: newLocation)
                .setResponseCode(responseCode: ResponseCodes.MOVED_PERMANENTLY)
    }

    public static func OptionsResponse(methods: [String]) -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.OK)
                .addHeader(key: "Allow", value: methods.joined(separator: ","))
    }

    public static func MethodNotAllowedResponse(methods: [String]) -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.METHOD_NOT_ALLOWED)
                .addHeader(key: "Allow", value: methods.joined(separator: ","))
    }

    public static func PartialContentResponse() -> HTTPResponse {
        return DefaultHeaders()
                .setResponseCode(responseCode: ResponseCodes.PARTIAL_CONTENT)
    }
}
