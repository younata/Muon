public struct Feed {
    public let title : String
    public let link : NSURL
    public let description : String
    public let language : NSLocale?
    public let lastUpdated : NSDate?
    public let publicationDate : NSDate?
    public let copyright : String?

    public let imageURL : NSURL?

    public private(set) var articles : [Article] = []

    init(title: String, link: NSURL, description : String, articles: [Article], language: NSLocale? = nil,
         lastUpdated : NSDate? = nil, publicationDate : NSDate? = nil, imageURL: NSURL? = nil, copyright: String? = nil) {
        self.title = title
        self.link = link
        self.description = description

        self.articles = articles

        self.language = language
        self.lastUpdated = lastUpdated
        self.publicationDate = publicationDate
        self.copyright = copyright
        self.imageURL = imageURL
    }

    mutating func addArticle(article : Article) {
        self.articles.append(article)
    }
}