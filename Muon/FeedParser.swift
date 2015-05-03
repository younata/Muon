import Foundation

public class FeedParser: NSOperation, NSXMLParserDelegate {
    public var parseHeaderOnly : Bool = false

    var feed : Feed? = nil

    var parser : NSXMLParser? = nil

    public var completion : (Feed) -> Void = {_ in }
    public var onFailure : (NSError) -> Void = {_ in }

    private var content : NSData

    public func success(onSuccess: (Feed) -> Void) -> FeedParser {
        completion = onSuccess
        return self
    }

    public func failure(failed: (NSError) -> Void) -> FeedParser {
        onFailure = failed
        return self
    }

    public init(string: String) {
        content = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        super.init()
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
        let parser = NSXMLParser(data: content)
        self.parser = parser
        parser.delegate = self
        parser.shouldProcessNamespaces = true
        currentPath = []
        articles = []
        parser.parse()
    }

    public func parserDidEndDocument(parser: NSXMLParser) {
        self.parser = nil
        if let feed = self.feed {
            self.completion(feed)
        } else {
            self.onFailure(NSError())
        }
    }

    public func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        self.parser = nil
        self.onFailure(parseError)
    }

    var currentPath : [String] = []
    var parseStructureAsContent = false
    var lastAttributes : [NSObject: AnyObject] = [:]

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

    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        let name = qName?.rangeOfString("content") != nil ? "content" : elementName
        currentPath.append(name.lowercaseString)
        if elementName == "channel" {
            feedHelper = FeedHelper()
        } else if elementName == "item" {
            articleHelper = ArticleHelper()
        }
        lastAttributes = attributeDict
        // enclosure for RSS 2.0-compatible feeds
        if currentPath == ["rss", "channel", "item", "enclosure"] {
            parseRSSEnclosure(attributeDict)
        }
        // image for RSS 1.0-compatible feeds
        if let imageURL = attributeDict["rdf:resource"] as? String where currentPath == ["rdf", "channel", "image"] {
            parseChannel("image", str: imageURL)
        }
        if let currentElement = currentPath.last where currentPath.first == "feed" && attributeDict.count != 0 { // Atom makes extensive use of attributes
            parseAtomItem(currentElement, attributeDict: attributeDict)
        }
    }

    public func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let str = string, currentItem = currentPath.last {
            if currentPath.first == "rss" || currentPath.first == "rdf" {
                if currentPath.count == 3 && currentPath[1] == "channel" { // RSS 1.0 & RSS 2.0 feed
                    parseChannel(currentItem, str: str)
                } else if currentPath.count == 4 && currentPath[1] == "channel" && currentPath[2] == "image" { // RSS 2.0 image
                    if currentItem == "url" && !str.hasOnlyWhitespace() {
                        parseChannel("image", str: str)
                    }
                } else if currentPath.count == 4 && currentPath[2] == "item" { // RSS 2.0 item
                    parseItem(currentItem, str: str)
                } else if currentPath.count > 2 && currentPath.first == "rdf" && currentPath[1] == "item" { // RSS 1.0 item
                    parseItem(currentItem, str: str)
                }
            } else if currentPath.first == "feed" {
                if contains(currentPath, "entry") {
                    parseItem(currentItem, str: str)
                } else {
                    parseChannel(currentItem, str: str)
                }
            }
        }
    }

    private func stringOrNil(string: String) -> String? {
        if (string == "") {
            return nil
        }
        return string
    }

    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        for (idx, item) in enumerate(currentPath.reverse()) {
            if item == elementName.lowercaseString {
                currentPath.removeAtIndex(currentPath.count - (idx + 1))
                break
            }
        }
        let rssDateFormatter = NSDateFormatter()
        rssDateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss zzz"
        if elementName == "channel" || elementName == "feed" {
            // parse and create a feed
            let link = NSURL(string: feedHelper.link)!
            let language = stringOrNil(feedHelper.language)
            let locale : NSLocale? = language != nil ? NSLocale(localeIdentifier: feedHelper.language) : nil
            let lastUpdated = feedHelper.lastUpdated.RFC822Date() ?? feedHelper.lastUpdated.RFC3339Date()
            let pubDate = feedHelper.publicationDate.RFC822Date()
            let copyright = stringOrNil(feedHelper.copyright)
            let imageURL = NSURL(string: feedHelper.imageURL)
            feed = Feed(title: feedHelper.title, link: link, description: feedHelper.description, articles: articles, language: locale,
                        lastUpdated: lastUpdated, publicationDate: pubDate, imageURL: imageURL, copyright: copyright)
        } else if elementName == "item" || elementName == "entry" {
            // parse and create an article
            let title = stringOrNil(articleHelper.title)
            let link = articleHelper.link != "" ? NSURL(string: articleHelper.link) : nil
            let guid = stringOrNil(articleHelper.guid)
            let description = stringOrNil(articleHelper.description)
            let content = stringOrNil(articleHelper.content)
            let published = articleHelper.published.RFC822Date()
            let updated = articleHelper.updated.RFC822Date()

            let article = Article(title: title, link: link, description: description, content: content, guid: guid, published: published, updated: updated, authors: [], enclosures: enclosures)

            if currentPath.first == "rdf" { // RSS 1.0
                feed?.addArticle(article)
            } else if currentPath.first == "rss" || currentPath.first == "feed" { // RSS 2.0 and Atom
                articles.append(article)
            }
            enclosures = []
        }
        lastAttributes = [:]
    }

    private func parseChannel(currentElement: String, str: String) {
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
        case "image":
            feedHelper.imageURL += str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        default: break
        }
    }

    private func parseItem(currentElement: String, str: String) {
        switch (currentElement) {
        case "title":
            articleHelper.title += str
        case "link":
            articleHelper.link += str
        case "guid":
            articleHelper.guid += str
        case "description":
            articleHelper.description += str
        case "pubdate":
            articleHelper.published += str
        case "content":
            articleHelper.content += str
        default: break
        }
    }

    private func parseAtomItem(currentElement: String, attributeDict: [NSObject: AnyObject]) {
        if !contains(currentPath, "entry") {
            if let rel = attributeDict["rel"] as? String, let href = attributeDict["href"] as? String where currentElement == "link" && rel == "self" {
                feedHelper.link = href
            }
        }
    }

    private func parseRSSEnclosure(attributeDict: [NSObject: AnyObject]) {
        if let url = NSURL(string: attributeDict["url"] as? String ?? ""),
            let type = attributeDict["type"] as? String,
            let lenStr = attributeDict["length"] as? String, let length = lenStr.toInt() {
                let enclosure = Enclosure(url: url, length: length, type: type)
                enclosures.append(enclosure)
        }
    }
}