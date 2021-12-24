import Foundation
#if os(Linux)
import FoundationXML
#endif

public enum FeedParserError: Error, Equatable {
    case noFeed
    case noData
    case noFeedParsed
    case parseError(Error)

    var localizedDescription: String {
        switch (self) {
        case .noFeed:
            return "No Feed Found"
        case .noData:
            return "Must be configured with data"
        case .noFeedParsed:
            return "Could not parse a feed"
        case .parseError(let underlyingError):
            return "Could not parse the feed - \(underlyingError)"
        }
    }

    public static func == (lhs: FeedParserError, rhs: FeedParserError) -> Bool {
        switch (lhs, rhs) {
        case (.noFeed, .noFeed), (.noData, .noData), (.noFeedParsed, .noFeedParsed):
            return true
        case (.parseError(let lhsError), .parseError(let rhsError)):
            return lhsError as NSError == rhsError as NSError
        default:
            return false
        }
    }
}

public final class FeedParser: Operation, XMLParserDelegate {
    public var completion : (Feed) -> Void = {_ in }
    public var onFailure : (FeedParserError) -> Void = {_ in }

    private var content : Data? = nil
    private var contentString : String? = nil

    public func success(_ onSuccess: @escaping (Feed) -> Void) -> FeedParser {
        completion = onSuccess
        return self
    }

    public func failure(_ failed: @escaping (FeedParserError) -> Void) -> FeedParser {
        onFailure = failed
        return self
    }

    public init(string: String) {
        contentString = string
        content = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        super.init()
    }

    public override init() {
        super.init()
    }

    public func configureWithString(_ string: String) {
        contentString = string
        content = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
    }

    // MARK - NSOperation

    public override func main() {
        parse()
    }

    public override func cancel() {
        stopParsing()
    }

    // MARK - Feed Parsing

    private func stopParsing() {
        parser?.abortParsing()
        parser = nil
    }

    private func parse() {
        if let content = self.content {
            if content.count == 0 {
                self.onFailure(FeedParserError.noFeed)
                return
            }
            let parser = XMLParser(data: content)
            self.parser = parser
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            currentPath = []
            articles = []
            _ = parser.parse()
        } else {
            self.onFailure(FeedParserError.noData)
        }
    }

    public func parserDidEndDocument(_ parser: XMLParser) {
        self.parser = nil
        if let feed = self.feed {
            self.completion(feed)
        } else {
            self.onFailure(FeedParserError.noFeedParsed)
        }
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parser = nil
        self.onFailure(.parseError(parseError))
    }

    private var feed : Feed? = nil
    private var parser : XMLParser? = nil

    private var currentPath : [String] = []
    private var parseStructureAsContent = false
    private var lastAttributes : [String: String] = [:]

    private var feedHelper = FeedHelper()

    private struct FeedHelper {
        var title : String = ""
        var link : String = ""
        var description : String = ""
        var language : String = ""
        var lastUpdated : String = ""
        var publicationDate : String = ""
        var copyright : String = ""

        var imageURL : String = ""
    }

    private var articleHelper = ArticleHelper()
    private var articles : [Article] = []

    private var enclosures : [Enclosure] = []

    private struct ArticleHelper {
        var title : String = ""
        var link : String = ""
        var guid : String = ""
        var description : String = ""
        var published : String = ""
        var updated : String = ""
        var content : String = ""
    }

    private var authorHelper = AuthorHelper()
    private var authors : [Author] = []
    private var feedAuthors : [Author] = []

    private struct AuthorHelper {
        var name : String = ""
        var email : String = ""
        var uri : String = ""
    }

    private var atomArticleContent : [String] = []
    private var atomXHTMLPath : [String]? = nil
    private var isAtomXHTML : Bool {
        if let path = atomXHTMLPath {
            if currentPath.count < path.count {
                return false
            }
            for (i,x) in path.enumerated() {
                if currentPath[i] != x {
                    return false
                }
            }
            return true
        }
        return false
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        let name: String
        if qName?.range(of: "content", options: .caseInsensitive, range: nil, locale: nil) != nil {
            name = "content"
        } else {
            name = elementName.lowercased()
        }
        currentPath.append(name)

        if isAtomXHTML {
            let previousItem = currentPath[currentPath.count - 2]
            if atomArticleContent.count != 0 {
                let previousIndex = atomArticleContent.count - 1
                let previousText = atomArticleContent[previousIndex]
                if previousText == parseAtomContentBeginTag(previousItem, attributes: lastAttributes) {
                    atomArticleContent[previousIndex] = previousText + ">"
                }
            }
            atomArticleContent.append(parseAtomContentBeginTag(name, attributes: attributeDict))
            lastAttributes = attributeDict
            return
        }
        lastAttributes = attributeDict

        if name == "channel" || name == "feed" {
            feedHelper = FeedHelper()
            feedAuthors = []
        } else if name == "item" || name == "entry" {
            articleHelper = ArticleHelper()
            authors = []
        } else if name == "content" && currentPath.first == "feed" && attributeDict["type"] == "xhtml" && !isAtomXHTML {
            atomXHTMLPath = currentPath
            atomArticleContent = []
        } else if currentPath == ["rss", "channel", "item", "enclosure"] { // enclosure for RSS 2.0-compatible feeds
            parseRSSEnclosure(attributeDict)
        } else if let imageURL = attributeDict["rdf:resource"] , currentPath == ["rdf", "channel", "image"] { // RSS 1.0 image
            parseChannel("image", str: imageURL)
        } else if let currentElement = currentPath.last , currentPath.first == "feed" && attributeDict.count != 0 { // Atom makes extensive use of attributes
            parseAtomItem(currentElement, attributeDict: attributeDict)
        } else if name == "author" {
            authorHelper = AuthorHelper()
        }
    }

    private func parseCharacters(_ string: String) {
        if let currentItem = currentPath.last {
            if let lastEntry = atomArticleContent.last , isAtomXHTML {
                if lastEntry.hasPrefix(parseAtomContentBeginTag(currentItem, attributes: lastAttributes)) {
                    atomArticleContent[atomArticleContent.count - 1] = lastEntry + ">"
                    atomArticleContent.append(string)
                } else {
                    atomArticleContent[atomArticleContent.count - 1] = lastEntry + string
                }
            } else if currentPath.first == "rss" || currentPath.first == "rdf" {
                if currentPath.count == 3 && currentPath[1] == "channel" { // RSS 1.0 & RSS 2.0 feed
                    parseChannel(currentItem, str: string)
                } else if currentPath.count == 4 && currentPath[1] == "channel" && currentPath[2] == "image" { // RSS 2.0 image
                    if currentItem == "url" && !string.hasOnlyWhitespace() {
                        parseChannel("image", str: string)
                    }
                } else if currentPath.count == 4 && currentPath[2] == "item" { // RSS 2.0 item
                    parseItem(currentItem, str: string)
                } else if currentPath.count > 2 && currentPath.first == "rdf" && currentPath[1] == "item" { // RSS 1.0 item
                    parseItem(currentItem, str: string)
                }
            } else if currentPath.first == "feed" {
                if currentPath.contains("entry") {
                    parseItem(currentItem, str: string)
                } else {
                    parseChannel(currentItem, str: string)
                }
            }
        }
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.parseCharacters(string)
    }

    public func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        self.parseCharacters(whitespaceString)
    }

    private func stringOrNil(_ string: String) -> String? {
        if (string == "") {
            return nil
        }
        return string
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let name = (qName?.range(of: "content") != nil ? "content" : elementName).lowercased()
        for (idx, item) in Array(currentPath.reversed()).enumerated() {
            if item == name.lowercased() {
                currentPath.remove(at: currentPath.count - (idx + 1))
                break
            }
        }
        if isAtomXHTML {
            if let lastEntry = atomArticleContent.last {
                if lastEntry == parseAtomContentBeginTag(name, attributes: lastAttributes) {
                    atomArticleContent[atomArticleContent.count - 1] = lastEntry + " />"
                } else {
                    atomArticleContent.append("</\(name)>")
                }
            }
            if atomXHTMLPath ?? [] == currentPath {
                // flatten atomArticleContent
                articleHelper.content = atomArticleContent.joined(separator: "")
                atomXHTMLPath = nil
            }
        } else if name == "channel" || name == "feed" {
            // parse and create a feed
            let link = URL(string: feedHelper.link)
            let language = stringOrNil(feedHelper.language)
            let locale : Locale? = language != nil ? Locale(identifier: feedHelper.language) : nil
            let lastUpdated = feedHelper.lastUpdated.RFC822Date() ?? feedHelper.lastUpdated.RFC3339Date()
            let pubDate = feedHelper.publicationDate.RFC822Date()
            let copyright = stringOrNil(feedHelper.copyright)
            let imageURL = URL(string: feedHelper.imageURL)
            feed = Feed(title: feedHelper.title, link: link, description: feedHelper.description, articles: articles, language: locale,
                        lastUpdated: lastUpdated, publicationDate: pubDate, imageURL: imageURL, copyright: copyright)
        } else if name == "item" || name == "entry" {
            // parse and create an article
            let title = stringOrNil(articleHelper.title)
            let link = !articleHelper.link.hasOnlyWhitespace() ? URL(string: articleHelper.link) : nil
            let guid = stringOrNil(articleHelper.guid)
            let description = stringOrNil(articleHelper.description)
            let content = stringOrNil(articleHelper.content)
            let published = articleHelper.published.RFC822Date() ?? articleHelper.published.RFC3339Date()
            let updated = articleHelper.updated.RFC822Date() ?? articleHelper.updated.RFC3339Date()

            let authorsToUse = authors.count == 0 ? feedAuthors : authors

            let article = Article(title: title, link: link as URL?, description: description, content: content, guid: guid, published: published, updated: updated, authors: authorsToUse, enclosures: enclosures)

            if currentPath.first == "rdf" { // RSS 1.0
                feed?.addArticle(article)
            } else if currentPath.first == "rss" || currentPath.first == "feed" { // RSS 2.0 and Atom
                articles.append(article)
            }
            enclosures = []
            authors = []
        } else if name == "author" || name == "contributor" {
            let name = authorHelper.name
            let email = !authorHelper.email.hasOnlyWhitespace() ? URL(string: authorHelper.email) : nil
            let uri = !authorHelper.uri.hasOnlyWhitespace() ? URL(string: authorHelper.uri) : nil
            let author = Author(name: name, email: email as URL?, uri: uri as URL?)
            if currentPath.contains("entry") || currentPath.contains("item") {
                authors.append(author)
            } else {
                feedAuthors.append(author)
            }
            authorHelper = AuthorHelper()
        }
        lastAttributes = [:]
    }

    private func parseChannel(_ currentElement: String, str: String) {
        if parseAuthor(currentElement, str: str) {
            return
        }
        switch (currentElement) {
        case "title":
            feedHelper.title += str
        case "link":
            feedHelper.link += str
        case "description", "subtitle":
            feedHelper.description += str
        case "language":
            feedHelper.language += str
        case "lastbuilddate", "updated":
            feedHelper.lastUpdated += str
        case "copyright", "rights":
            feedHelper.copyright += str
        case "image", "icon":
            feedHelper.imageURL += str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        default: break
        }
    }

    private func parseItem(_ currentElement: String, str: String) {
        if parseAuthor(currentElement, str: str) {
            return
        }
        switch (currentElement) {
        case "title":
            articleHelper.title += str
        case "link":
            articleHelper.link += str
        case "guid", "id":
            articleHelper.guid += str
        case "description", "summary":
            articleHelper.description += str
        case "pubdate", "published":
            articleHelper.published += str
        case "lastbuilddate", "updated":
            articleHelper.updated += str
        case "content":
            articleHelper.content += str
        default: break
        }
    }

    private func parseAuthor(_ currentElement: String, str: String) -> Bool {
        if currentPath.contains("author") || currentPath.contains("contributor") {
            if currentPath.first == "feed" { // Atom
                switch (currentElement) {
                case "name":
                    authorHelper.name += str
                case "email":
                    authorHelper.email += str
                case "uri":
                    authorHelper.uri += str
                default:
                    break
                }
            } else {
                authorHelper.name += str
            }
            return true
        }
        return false
    }

    private func parseRSSEnclosure(_ attributeDict: [String: String]) {
        if let url = URL(string: attributeDict["url"] ?? ""),
            let type = attributeDict["type"],
            let lenStr = attributeDict["length"], let length = Int(lenStr) {
                let enclosure = Enclosure(url: url, length: length, type: type)
                enclosures.append(enclosure)
        }
    }

    private func parseAtomItem(_ currentElement: String, attributeDict: [String: String]) {
        if currentPath.contains("entry") {
            switch (currentElement) {
            case "link":
                if let href = attributeDict["href"] {
                    if attributeDict["rel"] == "enclosure" {
                        if let type = attributeDict["type"], let lengthString = attributeDict["length"],
                            let length = Int(lengthString), let href = attributeDict["href"], let url = URL(string: href) {
                                let enclosure = Enclosure(url: url, length: length, type: type)
                                enclosures.append(enclosure)
                        }
                    } else {
                        articleHelper.link = href
                    }
                }
            default:
                break;
            }
        } else {
            if let href = attributeDict["href"], currentElement == "link" {
                if attributeDict["rel"] == nil || attributeDict["rel"] == "self" || attributeDict["rel"] == "alternate" {
                    feedHelper.link = href
                }
            }
        }
    }

    private func parseAtomContentBeginTag(_ tag: String, attributes: [String: String]) -> String {
        var ret = "<\(tag)"
        for (key, val) in attributes {
            ret += " \(key)=\"\(val.escapeHtml())\""
        }
        return ret
    }
}
