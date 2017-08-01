public struct simpleURL {
    let path: String
    let baseName: String
    let fullName: String

    public init(path: String, baseName: String) {
        self.path = path
        self.baseName = baseName
        self.fullName = path + baseName
    }
}