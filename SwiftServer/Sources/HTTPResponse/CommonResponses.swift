public struct CommonResponses {
    public static let OKResponse = HTTPResponse()
            .setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.OK)

    public static let NotFoundResponse = HTTPResponse()
            .setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.NOT_FOUND)

    public static let badRequestResponse = HTTPResponse()
            .setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.BAD_REQUEST)

    public static func FoundResponse(newLocation: String) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .addHeader(key: "Location", value: newLocation)
                .setResponseCode(responseCode: ResponseCodes.FOUND)
    }

    public static func MovedPermanentlyResponse(newLocation: String) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .addHeader(key: "Location", value: newLocation)
                .setResponseCode(responseCode: ResponseCodes.MOVED_PERMANENTLY)
    }

    public static func OptionsResponse(methods: [String]) -> HTTPResponse {
        return HTTPResponse()
                .setVersion(version: 1.1)
                .setResponseCode(responseCode: ResponseCodes.OK)
                .addHeader(key: "Allow", value: methods.joined(separator: ","))
    }
}
