import XCTest
import Socket
@testable import Server

class SwiftServerTests: XCTestCase {
    var server: Server!
    var queue: DispatchQueue!

    override func setUp() {
        super.setUp()
        do {
            server = try Server(portNumber: 5000, directory: "/tmp")
            queue = DispatchQueue(label: "queue1", qos: .background)
            queue.async {
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

    func testCanReadWrite() {
        var readData = Data()
        do {
            let clientSocket = try Socket.create()
            try clientSocket.connect(to: server.listener.remoteHostname, port: Int32(server.portNumber))
            try clientSocket.write(from: "HI")
            _ = try clientSocket.read(into: &readData)
            guard let response = String(data: readData, encoding: String.Encoding.utf8) else {
                print("Couldn't Interpret response")
                XCTFail()
                return
            }
            XCTAssertNotNil(response)
        } catch {
            XCTFail()
        }
    }
}
