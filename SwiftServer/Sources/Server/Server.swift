import Foundation
import Socket
import HTTPResponse
import HTTPRequest

enum ServerErrors: Error {
    case socketCreationFailed
    case badRequest
}

public class Server {
    let portNumber: Int
    let directory: String
    let hostName: String
    var serverRunning: Bool
    var routes: Routes!
    public var listener: Socket
    let badRequestResponse = HTTPResponse().setVersion(version: 1.1)
            .setResponseCode(responseCode: ResponseCodes.BAD_REQUEST)
            .generateResponse()

    public init(portNumber: Int, directory: String, hostName: String = "127.0.0.1") throws {
        self.portNumber = portNumber
        self.directory = directory
        self.serverRunning = false
        self.hostName = hostName
        do {
            self.listener = try Socket.create()
            try listener.listen(on: portNumber)
        } catch {
            throw ServerErrors.socketCreationFailed
        }
    }

    public func start() throws {
        routes = setupRoutes()
        serverRunning = true
        repeat {
            let clientSocket = try listener.acceptClientConnection()
            guard let request = try? readClientSocket(clientSocket: clientSocket),
                  let parsedRequest = try? parseRequest(request: request) else {
                try clientSocket.write(from: badRequestResponse)
                clientSocket.close()
                continue
            }
            try respond(startLine: parsedRequest.startLine, clientSocket: clientSocket)
        } while serverRunning
    }

    public func stop() {
        serverRunning = false
        listener.close()
    }

    private func respond(startLine: RequestLine, clientSocket: Socket) throws {
        let response = routes.routeRequest(target: startLine.target, method: startLine.httpMethod)
        let responseData = response.generateResponse()
        try clientSocket.write(from: responseData)
        clientSocket.close()
    }

    private func parseRequest(request: String) throws -> HTTPRequestParser {
        guard let parsedRequest = try? HTTPRequestParser(request: request) else {
            throw ServerErrors.badRequest
        }
        return parsedRequest
    }

    private func readClientSocket(clientSocket: Socket) throws -> String {
        var readData = Data()
        _ = try clientSocket.read(into: &readData)
        guard let request = String(data: readData, encoding: String.Encoding.utf8) else {
            throw ServerErrors.badRequest
        }
        if request.hasPrefix("QUIT") {
            clientSocket.close()
            stop()
        }
        return request
    }
}
