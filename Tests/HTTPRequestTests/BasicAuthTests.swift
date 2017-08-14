import Foundation
import XCTest
@testable import HTTPRequest

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