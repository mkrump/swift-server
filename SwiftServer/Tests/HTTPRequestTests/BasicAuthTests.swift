import Foundation
import XCTest
@testable import HTTPRequest

func decodeBasicAuth(challengeResponse: String) -> (userName: String, passWord: String)? {
    let parsedChallengeResponse = challengeResponse.components(separatedBy: " ")
    if let data = Data(base64Encoded: parsedChallengeResponse[1]),
       let decodedChallenge = String(data: data, encoding: .utf8) {
        let params = decodedChallenge.components(separatedBy: ":")
        return (userName: params[0], passWord: params[1])
    }
    return nil
}

class BasicAuthTests: XCTestCase {
    func testBasicAuthValid() {
        let userName = "admin"
        let passWord = "hunter2"
        let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic YWRtaW46aHVudGVyMg==\r\n",
                headerDict: ["Authorization": "Basic YWRtaW46aHVudGVyMg=="])
        guard let headerDict = mockHeaders.headerDict,
              let credentials = headerDict["Authorization"],
              let params = decodeBasicAuth(challengeResponse: credentials) else {
            XCTFail()
            return
        }
        XCTAssertEqual(params.userName, userName)
        XCTAssertEqual(params.passWord, passWord)
    }
}