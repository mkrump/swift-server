import Foundation
import Socket
import HTTPResponse
import HTTPRequest
import Routes
import AppRoutes
import FileSystem

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
    var fileManager: FileSystem
    var logger: Logger?
    public var listener: Socket

    public init(portNumber: Int, directory: String, hostName: String = "127.0.0.1", logPath: String? = nil) throws {
        self.portNumber = portNumber
        self.directory = directory
        self.serverRunning = false
        self.hostName = hostName
        self.fileManager = ServerFileManager()
        do {
            self.listener = try Socket.create()
            try listener.listen(on: portNumber)
        } catch {
            throw ServerErrors.socketCreationFailed
        }
        if let logPath = logPath {
            self.logger = try Logger(path: logPath)
        }
    }

    public func start() throws {
        routes = setupRoutes(path: directory, fileManager: fileManager, logPath: logger?.path)
        serverRunning = true
        repeat {
            let clientSocket = try listener.acceptClientConnection()
            guard let request = try? readClientSocket(clientSocket: clientSocket),
                  let parsedRequest = try? parseRequest(request: request) else {
                try clientSocket.write(from: CommonResponses.badRequestResponse().generateResponse())
                clientSocket.close()
                continue
            }
            if let logger = logger {
                logger.appendLog(contents: parsedRequest.requestLine.rawRequestLine)
            }
            try respond(request: parsedRequest, clientSocket: clientSocket)
        } while serverRunning
    }

    public func stop() {
        serverRunning = false
        listener.close()
    }

    private func respond(request: HTTPRequestParse, clientSocket: Socket) throws {
        let url = simpleURL(path: self.directory, baseName: request.requestLine.target)
        let response = routes.routeRequest(request: request, url: url, fileManager: fileManager)
        let responseData = response.generateResponse()
        try clientSocket.write(from: responseData)
        clientSocket.close()
    }

    private func parseRequest(request: String) throws -> HTTPRequestParse {
        guard let parsedRequest = try? HTTPParsedRequest(request: request) else {
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
