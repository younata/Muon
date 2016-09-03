import Foundation
public struct Feed {
    public let title: String
    public let link: URL?
    public let description: String
    public let language: NSLocale?
    public let lastUpdated: Date?
    public let publicationDate: Date?
    public let copyright: String?

    public let imageURL: URL?

    private var internalArticles: [Article] = []

    public var articles: [Article] { return internalArticles }

    public init(title: String, link: URL?, description : String, articles: [Article], language: NSLocale? = nil,
         lastUpdated : Date? = nil, publicationDate : Date? = nil, imageURL: URL? = nil, copyright: String? = nil) {
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

    mutating func addArticle(_ article : Article) {
        self.internalArticles.append(article)
    }
}
