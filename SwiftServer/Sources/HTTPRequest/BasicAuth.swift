import Foundation

public func decodeBasicAuth(challengeResponse: String) -> (userName: String, passWord: String)? {
    let parsedChallengeResponse = challengeResponse.components(separatedBy: " ")
    if let data = Data(base64Encoded: parsedChallengeResponse[1]),
       let decodedChallenge = String(data: data, encoding: .utf8) {
        let credentials = decodedChallenge.components(separatedBy: ":")
        return (userName: credentials[0], passWord: credentials[1])
    }
    return nil
}

public func authSuccess(headers: HeaderParse?, userName: String, password: String) -> Bool {
    guard let headers = headers,
          let headerDict = headers.headerDict,
          let base64EncodedCredentials = headerDict["Authorization"],
          let credentials = decodeBasicAuth(challengeResponse: base64EncodedCredentials) else {
        return false
    }
    return credentials.userName == userName && credentials.passWord == password
}
