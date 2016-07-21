public final class Article {
    public let title : String
    public let link : NSURL
    public let guid : String?
    public let description : String
    public let published : NSDate
    public let updated : NSDate?
    public let content : String

    private var internalAuthors : [Author]
    public var authors : [Author] { return internalAuthors }

    private var internalEnclosures : [Enclosure]
    public var enclosures : [Enclosure] { return internalEnclosures }

    public init(title: String? = nil, link: NSURL? = nil, description: String? = nil, content: String? = nil, guid: String? = nil,
         published: NSDate? = nil, updated: NSDate? = nil, authors: [Author] = [], enclosures: [Enclosure] = []) {
        self.title = title ?? ""
        self.link = link ?? NSURL(string: "")!
        self.description = description ?? ""
        self.guid = guid ?? ""
        self.published = published ?? NSDate()
        self.updated = updated
        self.content = content ?? ""

        self.internalAuthors = authors
        self.internalEnclosures = enclosures
    }

    public func addAuthor(author: Author) {
        self.internalAuthors.append(author)
    }

    public func addEnclosure(enclosure: Enclosure) {
        self.internalEnclosures.append(enclosure)
    }
}
