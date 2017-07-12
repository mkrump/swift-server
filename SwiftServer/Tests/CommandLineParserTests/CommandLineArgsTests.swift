import XCTest
@testable import CommandLineParser

class CommandLineArgsTests: XCTestCase {
    var directory: String!
    var port: String!
    var args: [String]!

    override func setUp() {
        super.setUp()
        directory = "dir1/dir2/"
        port = "8000"
        args = ["program", "-d", directory, "-p", port]
    }

    func testMissingRequiredCommandLineArgs() {
        let commandLineArgParser = CommandLineArgParser()
        args = Array(args.prefix(3))
        print(args)
        var cargs2 = args.map {
            strdup($0)
        }
        XCTAssertThrowsError(try commandLineArgParser.getOpt(argc: Int32(cargs2.count), argv: &cargs2))
        for ptr in cargs2 {
            free(ptr)
        }
        cargs2.removeAll()
        print(cargs2)
    }

    func testCommandLineArgs() {
        let commandLineArgParser = CommandLineArgParser()
        print(args)
        var cargs1 = args.map {
            strdup($0)
        }
        do {
            let argsArray = try commandLineArgParser.getOpt(argc: Int32(cargs1.count), argv: &cargs1)
            for ptr in cargs1 {
                free(ptr)
            }
            XCTAssertEqual(argsArray["directory"], directory)
            XCTAssertEqual(argsArray["portNumber"], port)
        } catch {
            print(cargs1)
            XCTFail()
        }
    }

//    static var allTests = [
//        ("testValidCommandLineArgs", testValidCommandLineArgs),
//        ("testMissingRequiredCommandLineArgs", testMissingRequiredCommandLineArgs),
//    ]
}
