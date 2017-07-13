import XCTest
@testable import CommandLineParser

class CommandLineArgsTests: XCTestCase {
    var directory: String!
    var port: Int!
    var commandLineArgs: [String]!

    override func setUp() {
        super.setUp()
        directory = "dir1/dir2/"
        port = 8000
        commandLineArgs = ["program", "-d", directory, "-p", String(port)]
    }

    func testCommandLineArgs() {
        let commandLineArgParser = CommandLineArgParser()
        var cargs1 = commandLineArgs.map {
            strdup($0)
        }
        defer {
            for ptr in cargs1 {
                free(ptr)
            }
        }
        do {
            let argsArray = try commandLineArgParser.getOpt(argc: Int32(cargs1.count), argv: &cargs1)
            XCTAssertEqual(argsArray.directory, directory)
            XCTAssertEqual(argsArray.portNumber, port)
        } catch {
            XCTFail()
        }
    }

    func testMissingRequiredCommandLineArgs() {
        let commandLineArgParser = CommandLineArgParser()
        commandLineArgs = Array(commandLineArgs.prefix(3))
        var cargs2 = commandLineArgs.map {
            strdup($0)
        }
        defer {
            for ptr in cargs2 {
                free(ptr)
            }
        }
        XCTAssertThrowsError(try commandLineArgParser.getOpt(argc: Int32(cargs2.count), argv: &cargs2))
        cargs2.removeAll()
    }

//    static var allTests = [
//        ("testValidCommandLineArgs", testValidCommandLineArgs),
//        ("testMissingRequiredCommandLineArgs", testMissingRequiredCommandLineArgs),
//    ]
}
