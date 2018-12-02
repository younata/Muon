import Foundation
public struct Article {
    public let title : String
    public let link : URL?
    public let guid : String?
    public let description : String
    public let published : Date
    public let updated : Date?
    public let content : String

    public private(set) var authors : [Author]

    public private(set) var enclosures : [Enclosure]

    public init(title: String? = nil, link: URL? = nil, description: String? = nil, content: String? = nil, guid: String? = nil,
         published: Date? = nil, updated: Date? = nil, authors: [Author] = [], enclosures: [Enclosure] = []) {
        self.title = title ?? ""
        self.link = link
        self.description = description ?? ""
        self.guid = guid ?? ""
        self.published = published ?? Date()
        self.updated = updated
        self.content = content ?? ""

        self.authors = authors
        self.enclosures = enclosures
    }

    mutating func addAuthor(_ author: Author) {
        self.authors.append(author)
    }

    mutating func addEnclosure(_ enclosure: Enclosure) {
        self.enclosures.append(enclosure)
    }
}
