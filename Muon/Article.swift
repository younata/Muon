@objc public class Article {
    @objc public let title : String?
    @objc public let link : NSURL?
    @objc public let guid : String?
    @objc public let description : String?
    @objc public let published : NSDate?
    @objc public let updated : NSDate?
    @objc public let content : String?

    private var internalAuthors : [Author]
    @objc public var authors : [Author] { return internalAuthors }

    private var internalEnclosures : [Enclosure]
    @objc public var enclosures : [Enclosure] { return internalEnclosures }

    @objc public init(title: String? = nil, link: NSURL? = nil, description: String? = nil, content: String? = nil, guid: String? = nil,
         published: NSDate? = nil, updated: NSDate? = nil, authors: [Author] = [], enclosures: [Enclosure] = []) {
        self.title = title
        self.link = link
        self.description = description
        self.guid = guid
        self.published = published
        self.updated = updated
        self.content = content

        self.internalAuthors = authors
        self.internalEnclosures = enclosures
    }

    @objc public func addAuthor(author: Author) {
        self.internalAuthors.append(author)
    }

    @objc public func addEnclosure(enclosure: Enclosure) {
        self.internalEnclosures.append(enclosure)
    }
}
