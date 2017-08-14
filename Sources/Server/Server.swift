import Foundation
import Socket
import HTTPResponse
import HTTPRequest
import Routes
import SimpleURL
import Dispatch
import Configuration
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
                self.logger = try Logger(url: simpleURL(path: self.directory, baseName: logPath))
            } catch {
                print("Couldn't create log file at: \(logPath)")
            }
        }
        routes = appConfig.serverRoutes
    }

    deinit {
        connections.values.forEach({ $0.close() })
        connections.removeAll()
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
        connections.removeAll()
        listener.close()
    }

    private func handleClientRequest(clientSocket: Socket) {
        self.connections[clientSocket.socketfd] = clientSocket
        guard let request = try? self.readClientSocket(clientSocket: clientSocket),
              let parsedRequest = try? self.parseRequest(request: request) else {
            _ = try? clientSocket.write(from: CommonResponses.badRequestResponse().generateResponse())
            closeClientSocket(clientSocket: clientSocket)
            return
        }
        logRequest(parsedRequest: parsedRequest)
        try? self.respond(request: parsedRequest, clientSocket: clientSocket)
    }

    private func readClientSocket(clientSocket: Socket) throws -> String {
        var readData = Data()
        _ = try clientSocket.read(into: &readData)
        guard let request = String(data: readData, encoding: String.Encoding.utf8) else {
            throw ServerErrors.badRequest
        }
        handleStopSignal(request: request, clientSocket: clientSocket)
        return request
    }

    private func closeClientSocket(clientSocket: Socket) {
        connections.removeValue(forKey: clientSocket.socketfd)
        clientSocket.close()
    }

    private func logRequest(parsedRequest: HTTPRequestParse) {
        if let logger = self.logger {
            let date = Date().dateToRFC822String()
            let request = parsedRequest.requestLine.rawRequestLine
            let logLine = "[\(date)] \(request)"
            logger.appendLog(contents: logLine)
        }
    }

    private func respond(request: HTTPRequestParse, clientSocket: Socket) throws {
        let relativeURL = request.requestLine.target.replacingOccurrences(of: self.directory, with: "")
        let url = simpleURL(path: self.directory, baseName: relativeURL)
        let response = routes.routeRequest(request: request, url: url, fileManager: fileManager)
        let responseData = response.generateResponse()
        try clientSocket.write(from: responseData)
        closeClientSocket(clientSocket: clientSocket)
    }

    private func parseRequest(request: String) throws -> HTTPRequestParse {
        guard let parsedRequest = try? HTTPParsedRequest(request: request) else {
            throw ServerErrors.badRequest
        }
        return parsedRequest
    }

    private func handleStopSignal(request: String, clientSocket: Socket) {
        if request.hasPrefix("QUIT") {
            clientSocket.close()
            stop()
        }
    }
}
