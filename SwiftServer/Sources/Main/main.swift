import CommandLineParser
import Server

let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
let server = try Server(portNumber: args.portNumber, directory: args.directory)
_ = try server.start()
