import XCTest
@testable import CommandLineParser

class CommandLineArgsTests: XCTestCase {
    func testCommandLineArgs() {
        let directory = "dir1/dir2/"
        let port = "8000"
        let args = ["program", "-d", directory, "-p", port]
        var cargs = args.map {
            strdup($0)
        }
        let commandLineArgParser = CommandLineArgParser()
        let argsArray = commandLineArgParser.getOpt(argc: Int32(args.count), argv: &cargs)
        print(argsArray)
        for ptr in cargs {
            free(ptr)
        }
        XCTAssertEqual(argsArray["directory"], directory)
        XCTAssertEqual(argsArray["portNumber"], port)
    }

    static var allTests = [
        ("testCommandLineArgs", testCommandLineArgs),
    ]
}
