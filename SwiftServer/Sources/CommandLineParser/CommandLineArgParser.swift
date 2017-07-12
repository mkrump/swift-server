import Foundation

enum CommandLineError: Error {
    case missingRequiredArgument
    case unknownOption
}

public class CommandLineArgParser {

    public init() {
    }

    public func getOpt(argc: Int32,
                       argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) throws -> [String: String] {

        var p: String?
        var d: String?

        while case let option = getopt(argc, argv, "d:p:"), option != -1 {
            switch UnicodeScalar(CUnsignedChar(option)) {
            case "p":
                p = String(cString: optarg)
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
        return ["portNumber": portValue, "directory": directory]
    }
}
