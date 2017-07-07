import Foundation
public struct Author {
    public let name: String
    public let email: URL?
    public let uri: URL?

    public init(name: String, email: URL? = nil, uri: URL? = nil) {
        self.name = name
        self.email = email
        self.uri = uri
    }
}
