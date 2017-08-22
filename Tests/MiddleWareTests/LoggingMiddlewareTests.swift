import XCTest
import HTTPResponse
import HTTPRequest
import FileSystem
import SimpleURL
import Routes
@testable import MiddleWare

class LoggingMiddlewareTests: XCTestCase {
    var routes: Routes!
    var path: String!
    var logFileName: String!
    var logUrl: simpleURL!
    var authMiddleware: LoggerMiddleware!
    var middlewareExecutor: MiddlewareExecutor!
    var secondStepAuth: Auth!

    override func setUp() {
        path = "./Tests/"
        logFileName = "test.log"
        logUrl = simpleURL(path: path, baseName: logFileName)
        authMiddleware = LoggerMiddleware(logPath: logUrl)
        middlewareExecutor = MiddlewareExecutor()
        middlewareExecutor.addMiddleWare(middleWare: authMiddleware)
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func generateMockResponses(target: String) -> MiddlewareResponse {
        let mockStartLine = MockRequestLine(httpMethod: "HEAD", target: target, httpVersion: "HTTP/1.1", rawRequestLine: "REQUEST")
        let mockHTTPParse = MockHTTParsedRequest(startLine: mockStartLine)
        let mockNoDirFileManager = MockIsRoute()
        let url = simpleURL(path: path, baseName: mockStartLine.target)
        return middlewareExecutor.execute(request: mockHTTPParse, url: url, fileManager: mockNoDirFileManager)
    }

    func testResponse() {
        let middlewareResponse = generateMockResponses(target: "/valid")
        XCTAssertNil(middlewareResponse.response)
    }

    func testFileWrite() {
        _ = generateMockResponses(target: "/valid")
        if let logContents = try? String(contentsOfFile: logUrl.fullName) {
            print(logContents)
            XCTAssertTrue(logContents.contains("REQUEST"))
        } else {
            XCTFail()
        }
    }
}