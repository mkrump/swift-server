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
            queue = DispatchQueue(label: "queue1", qos: .default)
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
}
