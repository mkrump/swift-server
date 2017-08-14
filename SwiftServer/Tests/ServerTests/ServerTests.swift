import XCTest
import Socket
import FileSystem
import AppRoutes
@testable import Server

class SwiftServerTests: XCTestCase {
    var server: Server!
    var queue: DispatchQueue!

    override func setUp() {
        super.setUp()
        do {
            let appConfig = AppConfig(
                    directory: "/tmp",
                    portNumber: 5000,
                    fileManager: ServerFileManager(),
                    logPath: "/server.log",
                    hostName: "127.0.0.1"
            )
            server = try Server(appConfig: appConfig)
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
