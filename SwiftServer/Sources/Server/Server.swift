import Foundation

class Server {
    var portNumber: String
    var directory: String

    init(portNumber: String, directory: String) {
        self.portNumber = portNumber
        self.directory = directory
    }

    func start() {
        print(directory)
        print(portNumber)
    }
}
