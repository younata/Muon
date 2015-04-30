import Quick
import Nimble
import Muon

class IntegrationSpec: QuickSpec {
    override func spec() {
        var parser : FeedParser! = nil
        let rssDateFormatter = NSDateFormatter()
        let atomDateFormatter = NSDateFormatter()

        var feed : Feed? = nil
        var parseError : NSError? = nil

        var parserWithContentsOfFile : String -> FeedParser = {fileName in
            let expectation = self.expectationWithDescription("parsing")
            let researchKit = String(contentsOfFile: fileName, encoding: NSUTF8StringEncoding, error: nil)!
            let parser = FeedParser(string: researchKit)
            parser.success { feed = $0; expectation.fulfill() }
            parser.failure { parseError = $0; expectation.fulfill() }

            parser.parse()
            self.waitForExpectationsWithTimeout(10, handler: { _ in });
            return parser
        }

        beforeEach {
            rssDateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss zzz"
            atomDateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ssZ"
        }

        describe("Apple") {
            beforeEach {
                parser = parserWithContentsOfFile("researchkit.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("ResearchKit Blog - ResearchKit.org"))
                    expect(feed.link).to(equal(NSURL(string: "http://researchkit.org/blog.html")!))
                    expect(feed.description).to(equal("Get the latest news and helpful tips on ResearchKit."))
                    expect(feed.language).to(equal(NSLocale(localeIdentifier: "en-US")))
                    let buildDate = "Tue, 14 Apr 2015 10:00:00 PDT"
                    let date = rssDateFormatter.dateFromString(buildDate)
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(1))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal(""))
                    expect(article.link).to(equal(NSURL(string: "http://researchkit.org/blog.html#article-1")))
                    expect(article.guid).to(equal("http://researchkit.org/blog.html#article-1"))
                    expect(article.description).to(equal(" On March 9, Apple introduced the world to  ResearchKit , a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.  This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.  You can get started with ResearchKit by visiting  GitHub , now available to all developers for free under the ResearchKit BSD license. Be sure to check out the  Overview  tab for great links to  documentation  and  sample code  to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.  We can’t wait to see what we discover together!  - The ResearchKit Team </description>"))
                    expect(article.content).to(equal("<![CDATA[<p>On March 9, Apple introduced the world to <a href=\"http://www.apple.com/researchkit/\">ResearchKit</a>, a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.</p><p>This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.</p><p>You can get started with ResearchKit by visiting <a href=\"https://github.com/ResearchKit/ResearchKit\">GitHub</a>, now available to all developers for free under the ResearchKit BSD license. Be sure to check out the <a href=\"index.html\">Overview</a> tab for great links to <a href=\"docs/docs/Overview/GuideOverview.html\">documentation</a> and <a href=\"https://github.com/ResearchKit/ResearchKit/tree/master/samples/ORKCatalog\">sample code</a> to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.</p><p>We can’t wait to see what we discover together!</p><p>- The ResearchKit Team</p>]]>"))
                    let published = "Tue, 14 Apr 2015 10:00:00 PDT"
                    let date = rssDateFormatter.dateFromString(published)
                    expect(article.published).to(equal(date))
                    expect(article.enclosures.count).to(equal(0))
                }
            }
        }

        describe("RSS 0.91") {
            beforeEach {
                parser = parserWithContentsOfFile("rss091.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("WriteTheWeb"))
                    expect(feed.link).to(equal(NSURL(string: "http://writetheweb.com")))
                    expect(feed.description).to(equal("News for web users that write back"))
                    expect(feed.language).to(equal(NSLocale(localeIdentifier: "en-us")))
                    expect(feed.copyright).to(equal("Copyright 2000, WriteTheWeb team."))
                    expect(feed.imageURL).to(equal(NSURL(string: "http://writetheweb.com/images/mynetscape88.gif")))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(1))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Giving the world a pluggable Gnutella"))
                    expect(article.link).to(equal(NSURL(string: "http://writetheweb.com/read.php?item=24")))
                    expect(article.description).to(equal("WorldOS is a framework on which to build programs that work like Freenet or Gnutella -allowing distributed applications using peer-to-peer routing."))
                }
            }
        }

        describe("RSS 0.92") {
            beforeEach {
                parser = parserWithContentsOfFile("rss092.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("Dave Winer: Grateful Dead"))
                    expect(feed.link).to(equal(NSURL(string: "http://www.scripting.com/blog/categories/gratefulDead.html")))
                    expect(feed.description).to(equal("A high-fidelity Grateful Dead song every day. This is where we're experimenting with enclosures on RSS news items that download when you're not using your computer. If it works (it will) it will be the end of the Click-And-Wait multimedia experience on the Internet."))
                    let date = rssDateFormatter.dateFromString("Fri, 13 Apr 2001 19:23:02 GMT")
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.description).to(equal("Moshe Weitzman says Shakedown Street is what I'm lookin for for tonight. I'm listening right now. It's one of my favorites. \"Don't tell me this town ain't got no heart.\" Too bright. I like the jazziness of Weather Report Suite. Dreamy and soft. How about The Other One? \"Spanish lady come to me..\""))
                }
                if let article = feed?.articles.last {
                    expect(article.description).to(equal("<a href=\"http://www.scripting.com/mp3s/youWinAgain.mp3\">;The news is out</a>, all over town..<p>\nYou've been seen, out runnin round. <p> The lyrics are <a href=\"http://www.cs.cmu.edu/~mleone/gdead/dead-lyrics/You_Win_Again.txt\">here</a>, short and sweet. <p> <i>You win again!</i>"))
                    expect(article.enclosures.count).to(equal(1))
                    if let enclosure = article.enclosures.first {
                        expect(enclosure.url).to(equal(NSURL(string: "http://www.scripting.com/mp3s/youWinAgain.mp3")))
                        expect(enclosure.length).to(equal(3874816))
                        expect(enclosure.type).to(equal("audio/mpeg"))
                    }
                }
            }
        }

        describe("RSS 1.0") {
            beforeEach {
                parser = parserWithContentsOfFile("rss100.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("XML.com"))
                    expect(feed.link).to(equal(NSURL(string: "http://xml.com/pub")))
                    expect(feed.description).to(equal("XML.com features a rich mix of information and services for the XML community."))
                    expect(feed.imageURL).to(equal(NSURL(string: "http://xml.com/universal/images/xml_tiny.gif")))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Processing Inclusions with XSLT"))
                    expect(article.link).to(equal(NSURL(string: "http://xml.com/pub/2000/08/09/xslt/xslt.html")))
                    expect(article.description).to(equal("Processing document inclusions with general XML tools can be problematic. This article proposes a way of preserving inclusion information through SAX-based processing."))
                }
                if let article = feed?.articles.last {
                    expect(article.title).to(equal("Putting RDF to Work"))
                    expect(article.link).to(equal(NSURL(string: "http://xml.com/pub/2000/08/09/rdfdb/index.html")))
                    expect(article.description).to(equal("Tool and API support for the Resource Description Framework is slowly coming of age. Edd Dumbill takes a look at RDFDB, one of the most exciting new RDF toolkits."))
                }
            }
        }

        describe("RSS 2.0") {
            beforeEach {
                parser = parserWithContentsOfFile("rss200.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("Liftoff News"))
                    expect(feed.link).to(equal(NSURL(string: "http://liftoff.msfc.nasa.gov/")))
                    expect(feed.description).to(equal("Liftoff to Space Exploration"))
                    expect(feed.language).to(equal(NSLocale(localeIdentifier: "en-us")))
                    let date = rssDateFormatter.dateFromString("Tue, 10 Jun 2003 09:41:01 GMT")
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Star City"))
                    expect(article.link).to(equal(NSURL(string: "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp")))
                    expect(article.description).to(equal("How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia's <a href=\"http://howe.iki.rssi.ru/GCTC/gctc_e.htm\">Star City</a>."))
                    let date = rssDateFormatter.dateFromString("Tue, 03 Jun 2003 09:39:21 GMT")
                    expect(article.published).to(equal(date))
                    expect(article.guid).to(equal("http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"))
                }
                if let article = feed?.articles.last {
                    expect(article.title).to(equal(""))
                    expect(article.link).to(beNil())
                    expect(article.description).to(equal("Sky watchers in Europe, Asia, and parts of Alaska and Canada will experience a <a href=\"http://science.nasa.gov/headlines/y2003/30may_solareclipse.htm\">partial eclipse of the Sun</a> on Saturday, May 31st."))
                    let date = rssDateFormatter.dateFromString("Fri, 30 May 2003 11:06:42 GMT")
                    expect(article.published).to(equal(date))
                    expect(article.guid).to(equal("http://liftoff.msfc.nasa.gov/2003/05/30.html#item572"))
                }
            }
        }

        describe("Atom 1.0") {
            beforeEach {
                parser = parserWithContentsOfFile("atom100.xml")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("Example Feed"))
                    expect(feed.link).to(equal(NSURL(string: "http://example.org/")))
                    let date = atomDateFormatter.dateFromString("2003-12-13T18:30:02Z")
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(1))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Atom-Powered Robots Run Amok"))
                    expect(article.link).to(equal(NSURL(string: "http://example.org/2003/12/13/atom03")))
                    expect(article.guid).to(equal("1225c695-cfb8-4ebb-aaaa-80da344efa6a"))
                    let date = atomDateFormatter.dateFromString("2003-12-13T18:30:02Z")
                    expect(article.updated).to(equal(date))
                    expect(article.description).to(equal("Some text."))
                }
            }
        }
    }
}
