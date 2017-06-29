import CommandLineParser

let commandArgLineParser = CommandLineArgParser()
let args = commandArgLineParser.getOpt(argc: CommandLine.argc, argv: CommandLine.unsafeArgv)
let server = Server()
server.start(args: args)
