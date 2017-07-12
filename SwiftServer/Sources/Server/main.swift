import CommandLineParser

let commandArgLineParser = CommandLineArgParser()
let args = try commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
let server = Server(portNumber: args["portNumber"]!, directory: args["directory"]!)
server.start()
