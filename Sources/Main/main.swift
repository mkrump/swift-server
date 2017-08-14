import Foundation
import CommandLineParser
import Configuration
import Server

let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
appConfig.directory = args.directory
appConfig.portNumber = args.portNumber
appConfig.serverRoutes = addRoutes(appConfig: appConfig)
let server = try Server(appConfig: appConfig)
_ = try server.start()
