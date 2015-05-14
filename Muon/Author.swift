@objc public class Author {
    @objc public let name : String
    @objc public let email : NSURL?
    @objc public let uri : NSURL?

    @objc public init(name: String, email: NSURL? = nil, uri: NSURL? = nil) {
        self.name = name
        self.email = email
        self.uri = uri
    }
}
