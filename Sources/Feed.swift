import Foundation
public struct Feed {
    public let title: String
    public let link: URL?
    public let description: String
    public let language: Locale?
    public let lastUpdated: Date?
    public let publicationDate: Date?
    public let copyright: String?

    public let imageURL: URL?

    public private(set) var articles: [Article] = []

    public init(title: String, link: URL?, description : String, articles: [Article], language: Locale? = nil,
         lastUpdated : Date? = nil, publicationDate : Date? = nil, imageURL: URL? = nil, copyright: String? = nil) {
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

    mutating func addArticle(_ article : Article) {
        self.articles.append(article)
    }
}
