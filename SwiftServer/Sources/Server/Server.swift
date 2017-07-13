import Foundation
import Socket

enum ServerErrors: Error {
    case socketCreationFailed
    case badRequest
}

public class Server {
    let portNumber: Int
    let directory: String
    let hostName: String
    var serverRunning: Bool
    public var listener: Socket

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
        serverRunning = true
        let responseData = Data("HTTP/1.1 200 OK\r\n\r\nHello!".utf8)
        repeat {
            var readData = Data()
            let clientSocket = try listener.acceptClientConnection()
            _ = try clientSocket.read(into: &readData)
            guard let request = String(data: readData, encoding: String.Encoding.utf8) else {
                throw ServerErrors.badRequest
            }
            if request.hasPrefix("ZZZ") {
                serverRunning = false
            }
            try clientSocket.write(from: responseData)
            clientSocket.close()
        } while serverRunning
    }

    public func stop() {
        serverRunning = false
        listener.close()
    }
}
