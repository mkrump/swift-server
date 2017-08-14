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
    var connections: [Int32: Socket] = [:]
    public var listener: Socket

    public init(appConfig: AppConfig) throws {
        self.portNumber = appConfig.portNumber
        self.directory = appConfig.directory
        self.serverRunning = false
        self.hostName = appConfig.hostName
        self.fileManager = appConfig.fileManager
        do {
            self.listener = try Socket.create()
            try listener.listen(on: portNumber)
        } catch {
            throw ServerErrors.socketCreationFailed
        }
        if let logPath = appConfig.logPath {
            do {
                self.logger = try Logger(path: logPath)
            } catch {
                print("Couldn't create log file at: \(logPath)")
            }
        }
        routes = appConfig.serverRoutes
    }

    deinit {
        connections.values.forEach({ $0.close() })
        listener.close()
    }

    public func start() throws {
        serverRunning = true
        let queue = DispatchQueue(label: "listenerQueue", attributes: .concurrent)
        repeat {
            let clientSocket = try self.listener.acceptClientConnection()
            queue.async {
                self.handleClientRequest(clientSocket: clientSocket)
            }
            continue
        } while self.serverRunning
    }

    public func stop() {
        serverRunning = false
        connections.values.forEach({ $0.close() })
        listener.close()
    }

    private func handleClientRequest(clientSocket: Socket) {
        self.connections[clientSocket.socketfd] = clientSocket
        guard let request = try? self.readClientSocket(clientSocket: clientSocket),
              let parsedRequest = try? self.parseRequest(request: request) else {
            _ = try? clientSocket.write(from: CommonResponses.badRequestResponse().generateResponse())
            connections.removeValue(forKey: clientSocket.socketfd)
            clientSocket.close()
            return
        }
        if let logger = self.logger {
            let date = Date().dateToRFC822String()
            let request = parsedRequest.requestLine.rawRequestLine
            let logLine = "[\(date)] \(request)"
            logger.appendLog(contents: logLine)
        }
        try? self.respond(request: parsedRequest, clientSocket: clientSocket)
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
