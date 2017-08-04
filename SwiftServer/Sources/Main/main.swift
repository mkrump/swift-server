import Foundation
import CommandLineParser
import Server

let logDir = "/Users/mathewkrump/Server/"
let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
let server = try Server(portNumber: args.portNumber, directory: args.directory, logPath: logDir + "server.log")
_ = try server.start()
