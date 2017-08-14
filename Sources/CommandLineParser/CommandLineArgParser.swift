import Foundation

public struct Args {
    public var portNumber: Int
    public var directory: String
}

enum CommandLineError: Error {
    case missingRequiredArgument
    case unknownOption
}

public class CommandLineArgParser {

    public init() {
    }

    public func getOpt(argc: Int32,
                       argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) throws -> Args {

        var p: Int?
        var d: String?

        while case let option = getopt(argc, argv, "d:p:"), option != -1 {
            switch UnicodeScalar(CUnsignedChar(option)) {
            case "p":
                p = Int(String(cString: optarg))
            case "d":
                d = String(cString: optarg)
            default:
                throw CommandLineError.unknownOption
            }
        }

        guard let portValue = p,
              let directory = d else {
            throw CommandLineError.missingRequiredArgument
        }
        return Args(portNumber: portValue, directory: directory)
    }
}
