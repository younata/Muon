import Foundation

public class FeedParser: NSOperation, NSXMLParserDelegate {
    public var parseHeaderOnly : Bool = false

    var feed : Feed? = nil

    var parser : NSXMLParser? = nil

    public var completion : (Feed) -> Void = {_ in }
    public var onFailure : (NSError) -> Void = {_ in }

    public func success(onSuccess: (Feed) -> Void) -> FeedParser {
        completion = onSuccess
        return self
    }

    public func failure(failed: (NSError) -> Void) -> FeedParser {
        onFailure = failed
        return self
    }

    public init(URL: NSURL, configuration: NSURLSessionConfiguration) {
        if URL.scheme == "file://" {
            let contents : String = NSString(contentsOfURL: URL, encoding: NSUTF8StringEncoding, error: nil)! as String
        } else {
        }

        super.init()
    }

    public init(string: String) {
        super.init()
    }

    public func stopParsing() {
        parser?.abortParsing()
        parser = nil
    }

    public func parse() {
        if let parser = parser {
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            parser.parse()
        } else {
            
        }
//        feedParser.feedParseType = parseInfoOnly ? ParseTypeInfoOnly : ParseTypeFull
    }

    public func parserDidEndDocument(parser: NSXMLParser) {
        self.parser = nil
    }

//    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
//        onFailure(error)
//    }

    var currentPath = ""
    var parseStructureAsContent = false

    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if let qName = qName {
            currentPath += "/" + qName
        }
    }

    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    }

//    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
//        self.info = info
//        if parseInfoOnly {
//            parser.stopParsing()
//        }
//    }

//    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
//        self.items.append(item)
//    }

//    func feedParserDidFinish(parser: MWFeedParser!) {
//        if let i = info {
//            dispatch_async(dispatch_get_main_queue()) {
//                self.completion(i, self.items)
//            }
//        }
//    }
}