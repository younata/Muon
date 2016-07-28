public struct Author {
    public let name: String
    public let email: NSURL?
    public let uri: NSURL?

    public init(name: String, email: NSURL? = nil, uri: NSURL? = nil) {
        self.name = name
        self.email = email
        self.uri = uri
    }
}
