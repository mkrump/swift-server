import Foundation

enum CommandLineError: Error {
    case invalidArgument
}

public class CommandLineArgParser {
    public init() {
    }

    public func getOpt(argc: Int32, argv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>) -> [String: String] {
        var portValue: String?
        var directoryValue: String?

        while case let option = getopt(argc, argv, "d:p:"), option != -1 {
            switch UnicodeScalar(CUnsignedChar(option)) {
            case "p":
                portValue = String(cString: optarg)
            case "d":
                directoryValue = String(cString: optarg)
            default:
                fatalError("Unknown option")
            }
        }
        return ["portNumber": portValue!, "directory": directoryValue!]
    }
}
