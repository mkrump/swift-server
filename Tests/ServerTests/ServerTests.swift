import XCTest
import Socket
import FileSystem
import Configuration
@testable import Server

class SwiftServerTests: XCTestCase {
    var server: Server!
    var queue: DispatchQueue!

    override func setUp() {
        super.setUp()
        do {
            let appConfig = App(
                    directory: "/tmp",
                    portNumber: 5000,
                    fileManager: ServerFileManager(),
                    logPath: "/server.log",
                    hostName: "127.0.0.1"
            )
            server = try Server(appConfig: appConfig)
            queue = DispatchQueue(label: "queue1", qos: .default)
            queue.asyncAfter(deadline: .now() + 0.25) {
                do {
                    try self.server.start()
                } catch {
                    XCTFail()
                }
            }
        } catch {
            print("Server setup failed")
            XCTFail()
        }
    }

    override func tearDown() {
        super.tearDown()
        server.stop()
    }

    func testCanConnect() {
        do {
            let clientSocket = try Socket.create()
            try clientSocket.connect(to: server.listener.remoteHostname, port: Int32(server.portNumber))
            XCTAssertTrue(clientSocket.isConnected)
        } catch {
            XCTFail()
        }
    }

    func testQuit() {
        do {
            let clientSocket = try Socket.create()
            try clientSocket.connect(to: server.listener.remoteHostname, port: Int32(server.portNumber))
            XCTAssertTrue(clientSocket.isConnected)
            try clientSocket.write(from: Data("QUIT".utf8))
        } catch {
            XCTFail()
        }
        XCTAssertFalse(server.serverRunning)
    }
}
