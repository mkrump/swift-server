import Foundation
import Socket
import HTTPResponse
import HTTPRequest
import Routes
import SimpleURL
import MiddleWare
import Dispatch
import Configuration
import FileSystem

public class Server {
    let portNumber: Int
    let directory: String
    let hostName: String
    var serverRunning: Bool
    var serverRequestParser: ServerRequestParsing
    var routes: Routes!
    var fileManager: FileSystem
    var middleWare: MiddlewareExecutor?
    var connections: [Int32: Socket] = [:]
    public var listener: Socket!

    public init(appConfig: App) throws {
        self.serverRequestParser = ServerRequestParser()
        self.portNumber = appConfig.portNumber
        self.directory = appConfig.directory
        self.serverRunning = false
        self.hostName = appConfig.hostName
        self.fileManager = appConfig.fileManager
        try addListener()
    }

    private func addListener() throws {
        do {
            self.listener = try Socket.create()
            try listener.listen(on: portNumber)
        } catch {
            throw ServerErrors.socketCreationFailed
        }
    }

    public func addRoutes(routes: Routes) {
        self.routes = routes
    }

    public func addMiddleware(middleware: MiddlewareExecutor) {
        self.middleWare = middleware
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
              let parsedRequest = try? serverRequestParser.parseRequest(request: request) else {
            _ = try? clientSocket.write(from: CommonResponses.badRequestResponse().generateResponse())
            closeClientSocket(clientSocket: clientSocket)
            return
        }
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

    private func applyMiddleware(middleWare: MiddlewareExecutor, request: HTTPRequestParse, clientSocket: Socket, url: simpleURL) throws {
        let middlewareResponse = middleWare.execute(request: request, url: url, fileManager: fileManager)
        switch (middlewareResponse.request, middlewareResponse.response) {
            case let (_, .some(middlewareResponse)):
                try transmitResponse(response: middlewareResponse, clientSocket: clientSocket)
            case let (request, nil):
                let response = routes.routeRequest(request: request, url: url, fileManager: fileManager)
                try transmitResponse(response: response, clientSocket: clientSocket)
        }
    }

    private func respond(request: HTTPRequestParse, clientSocket: Socket) throws {
        var response: HTTPResponse
        let relativeURL = request.requestLine.target.replacingOccurrences(of: self.directory, with: "")
        let url = simpleURL(path: self.directory, baseName: relativeURL)
        if let middleWare = middleWare {
            try applyMiddleware(middleWare: middleWare, request: request, clientSocket: clientSocket, url: url)
        } else {
            response = routes.routeRequest(request: request, url: url, fileManager: fileManager)
            try transmitResponse(response: response, clientSocket: clientSocket)
        }
    }

    private func transmitResponse(response: HTTPResponse, clientSocket: Socket) throws {
        let responseData = response.generateResponse()
        try clientSocket.write(from: responseData)
        closeClientSocket(clientSocket: clientSocket)
    }

    private func handleStopSignal(request: String, clientSocket: Socket) {
        if request.hasPrefix("QUIT") {
            clientSocket.close()
            stop()
        }
    }
}
