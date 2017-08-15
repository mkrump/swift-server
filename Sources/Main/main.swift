import Foundation
import CommandLineParser
import Configuration
import Server
import MiddleWare

var credentials = Auth(credentials: ["admin": "hunter2"])
let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
appConfig.directory = args.directory
appConfig.portNumber = args.portNumber
appConfig.serverRoutes = addRoutes(appConfig: appConfig)
appConfig.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/logs")
appConfig.middleware!.addMiddleWare(middleWare: AuthMiddleware(auth: credentials), route: "/admin")
let server = try Server(appConfig: appConfig)
_ = try server.start()
