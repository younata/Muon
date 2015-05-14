@objc public class Feed {
    @objc public let title : String
    @objc public let link : NSURL
    @objc public let description : String
    @objc public let language : NSLocale?
    @objc public let lastUpdated : NSDate?
    @objc public let publicationDate : NSDate?
    @objc public let copyright : String?

    @objc public let imageURL : NSURL?

    private var internalArticles : [Article] = []

    @objc public var articles : [Article] { return internalArticles }

    @objc public init(title: String, link: NSURL, description : String, articles: [Article], language: NSLocale? = nil,
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

    @objc public func addArticle(article : Article) {
        self.internalArticles.append(article)
    }
}
