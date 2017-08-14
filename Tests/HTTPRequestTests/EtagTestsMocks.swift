import Foundation
import HTTPRequest

public class MockHeaders: HeaderParse {
    public var rawHeaders: String?
    public var headerDict: [String: String]?

    public init(rawHeaders: String, headerDict: [String: String]) {
        self.rawHeaders = rawHeaders
        self.headerDict = headerDict
    }
}