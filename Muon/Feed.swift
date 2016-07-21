public final class Feed {
    public let title: String
    public let link: NSURL
    public let description: String
    public let language: NSLocale?
    public let lastUpdated: NSDate?
    public let publicationDate: NSDate?
    public let copyright: String?

    public let imageURL: NSURL?

    private var internalArticles: [Article] = []

    public var articles: [Article] { return internalArticles }

    public init(title: String, link: NSURL, description : String, articles: [Article], language: NSLocale? = nil,
         lastUpdated : NSDate? = nil, publicationDate : NSDate? = nil, imageURL: NSURL? = nil, copyright: String? = nil) {
        self.title = title
        self.link = link
        self.description = description

        self.internalArticles = articles

        self.language = language
        self.lastUpdated = lastUpdated
        self.publicationDate = publicationDate
        self.copyright = copyright
        self.imageURL = imageURL
    }

    public func addArticle(article : Article) {
        self.internalArticles.append(article)
    }
}
