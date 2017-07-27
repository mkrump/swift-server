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
}
