import Foundation
import CommandLineParser
import Configuration
import Server

let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
var app = createSwiftApp(directory: args.directory, portNumber: args.portNumber)
let server = try Server(appConfig: app)
server.addRoutes(routes: app.serverRoutes)
if let middleware = app.middleware {
    server.addMiddleware(middleware: middleware)
}
_ = try server.start()
