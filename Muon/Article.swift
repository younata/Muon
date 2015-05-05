public struct Article {
    public let title : String?
    public let link : NSURL?
    public let guid : String?
    public let description : String?
    public let published : NSDate?
    public let updated : NSDate?
    public let content : String?

    public private(set) var authors : [Author]
    public private(set) var enclosures : [Enclosure]

    public init(title: String? = nil, link: NSURL? = nil, description: String? = nil, content: String? = nil, guid: String? = nil,
         published: NSDate? = nil, updated: NSDate? = nil, authors: [Author] = [], enclosures: [Enclosure] = []) {
        self.title = title
        self.link = link
        self.description = description
        self.guid = guid
        self.published = published
        self.updated = updated
        self.content = content

        self.authors = authors
        self.enclosures = enclosures
    }

    public mutating func addAuthor(author: Author) {
        self.authors.append(author)
    }

    public mutating func addEnclosure(enclosure: Enclosure) {
        self.enclosures.append(enclosure)
    }
}