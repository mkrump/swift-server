import Foundation
import XCTest
@testable import HTTPRequest

func decodeBasicAuth(challengeResponse: String) -> (userName: String, passWord: String)? {
    let parsedChallengeResponse = challengeResponse.components(separatedBy: " ")
    if let data = Data(base64Encoded: parsedChallengeResponse[1]),
       let decodedChallenge = String(data: data, encoding: .utf8) {
        let credentials = decodedChallenge.components(separatedBy: ":")
        return (userName: credentials[0], passWord: credentials[1])
    }
    return nil
}

func authSuccess(headers: HeaderParse?, userName: String, password: String) -> Bool {
    guard let headers = headers,
          let headerDict = headers.headerDict,
          let base64EncodedCredentials = headerDict["Authorization"],
          let credentials = decodeBasicAuth(challengeResponse: base64EncodedCredentials) else {
        return false
    }
    return credentials.userName == userName && credentials.passWord == password
}

class BasicAuthTests: XCTestCase {
    func testBasicAuthDecode() {
        let userName = "admin"
        let passWord = "hunter2"
        let base64EncodedString = Data((userName + ":" + passWord).utf8).base64EncodedString()
        let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic " + base64EncodedString,
                headerDict: ["Authorization": "Basic " + base64EncodedString])
        guard let headerDict = mockHeaders.headerDict,
              let credentials = headerDict["Authorization"],
              let params = decodeBasicAuth(challengeResponse: credentials) else {
            XCTFail()
            return
        }
        XCTAssertEqual(params.userName, userName)
        XCTAssertEqual(params.passWord, passWord)
    }

    func testBasicAuthCorrect() {
        let userName = "admin"
        let passWord = "hunter2"
        let base64EncodedString = Data((userName + ":" + passWord).utf8).base64EncodedString()
        let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic " + base64EncodedString,
                headerDict: ["Authorization": "Basic " + base64EncodedString])
        XCTAssertTrue(authSuccess(headers: mockHeaders, userName: userName, password: passWord))
    }

    func testBasicAuthIncorrect() {
        let userName = "admin"
        let passWord = "hunter2"
        let passwordAttempt = "wrong"
        let base64EncodedString = Data((userName + ":" + passwordAttempt).utf8).base64EncodedString()
        let mockHeaders = MockHeaders(rawHeaders: "Authorization: Basic " + base64EncodedString,
                headerDict: ["Authorization": "Basic " + base64EncodedString])
        XCTAssertFalse(authSuccess(headers: mockHeaders, userName: userName, password: passWord))
    }
}