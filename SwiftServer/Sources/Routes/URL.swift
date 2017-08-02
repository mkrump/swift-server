public struct simpleURL {
    public let path: String
    public let baseName: String
    public let fullName: String

    public init(path: String, baseName: String) {
        self.path = path
        self.baseName = baseName
        self.fullName = path + baseName
    }
}