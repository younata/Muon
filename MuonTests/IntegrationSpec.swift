import Quick
import Nimble
import Muon

class IntegrationSpec: QuickSpec {
    override func spec() {
        var parser: FeedParser! = nil

        var feed: Feed? = nil

        let parserWithContentsOfFile : String -> FeedParser = {fileName in
            let location = NSBundle(forClass: self.classForCoder).pathForResource(fileName, ofType: nil)!
            let contents = try! String(contentsOfFile: location, encoding: NSUTF8StringEncoding)
            let parser = FeedParser(string: contents)
            parser.success { feed = $0; }

            parser.main()

            return parser
        }

        afterEach {
            parser = nil
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
                    let buildDate = "Tue, 14 Apr 2015 10:00:00 PDT".RFC822Date()
                    expect(feed.lastUpdated).to(equal(buildDate))
                    expect(feed.copyright).to(equal("Copyright 2015, Apple Inc."))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(1))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Welcome to ResearchKit!"))
                    expect(article.link).to(equal(NSURL(string: "http://researchkit.org/blog.html#article-1")))
                    expect(article.guid).to(equal("http://researchkit.org/blog.html#article-1"))
                    expect(article.description).to(equal(" On March 9, Apple introduced the world to  ResearchKit , a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.  This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.  You can get started with ResearchKit by visiting  GitHub , now available to all developers for free under the ResearchKit BSD license. Be sure to check out the  Overview  tab for great links to  documentation  and  sample code  to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.  We can’t wait to see what we discover together!  - The ResearchKit Team "))
                    // these two strings are equal, according to diff. Yet the equal matcher fails.
                    expect(article.content).to(match("<p>On March 9, Apple introduced the world to <a href=\"http://www.apple.com/researchkit/\">ResearchKit</a>, a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.</p><p>This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.</p><p>You can get started with ResearchKit by visiting <a href=\"https://github.com/ResearchKit/ResearchKit\">GitHub</a>, now available to all developers for free under the ResearchKit BSD license. Be sure to check out the <a href=\"index.html\">Overview</a> tab for great links to <a href=\"docs/docs/Overview/GuideOverview.html\">documentation</a> and <a href=\"https://github.com/ResearchKit/ResearchKit/tree/master/samples/ORKCatalog\">sample code</a> to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.</p><p>We can’t wait to see what we discover together!</p><p>- The ResearchKit Team</p>"))
                    let published = "Tue, 14 Apr 2015 10:00:00 PDT".RFC822Date()
                    expect(article.published).to(equal(published))
                    expect(article.enclosures.count).to(equal(0))
                }
            }
        }

        describe("Sparkfun") {
            beforeEach {
                parser = parserWithContentsOfFile("sparkfun.rss")
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("SparkFun Electronics Blog Posts"))
                    expect(feed.link).to(equal(NSURL(string: "https://www.sparkfun.com/news")!))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(20))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Photon Kit contest winners"))
                    expect(article.link).to(equal(NSURL(string: "https://www.sparkfun.com/news/1910")))
                    expect(article.guid).to(equal("urn:uuid:b591fe6f-ed76-e46a-ffc0-66cac3fac399"))
                    expect(article.description).to(beNil())
                    let loadedString = try? String(contentsOfFile: NSBundle(forClass: self.classForCoder).pathForResource("sparkfun1", ofType: "html")!, encoding: NSUTF8StringEncoding).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    expect(article.content).to(match(loadedString))
                    let updated = "2015-08-25T08:43:06-06:00".RFC3339Date()
                    expect(article.published).to(beNil())
                    expect(article.updated).to(equal(updated))
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
                    expect(feed.description).to(equal("A high-fidelity Grateful Dead song every day. This is where we're experimenting with enclosures on RSS news items that download when you're not using your computer. If it works (it will) it will be the end of the Click-And-Wait multimedia experience on the Internet. "))
                    let date = "Fri, 13 Apr 2001 19:23:02 GMT".RFC822Date()
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.description).to(equal("Moshe Weitzman says Shakedown Street is what I'm lookin for for tonight. I'm listening right now. It's one of my favorites. \"Don't tell me this town ain't got no heart.\" Too bright. I like the jazziness of Weather Report Suite. Dreamy and soft. How about The Other One? \"Spanish lady come to me..\""))
                }
                if let article = feed?.articles.last {
                    expect(article.description).to(equal("<a href=\"http://www.scripting.com/mp3s/youWinAgain.mp3\">The news is out</a>, all over town..<p>You've been seen, out runnin round. <p>The lyrics are <a href=\"http://www.cs.cmu.edu/~mleone/gdead/dead-lyrics/You_Win_Again.txt\">here</a>, short and sweet. <p><i>You win again!</i>"))
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
                    expect(feed.description).to(match("XML.com features a rich mix of information and services for the XML community."))
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
                    expect(feed.description).to(equal("Liftoff to Space Exploration."))
                    expect(feed.language).to(equal(NSLocale(localeIdentifier: "en-us")))
                    let date = "Tue, 10 Jun 2003 09:41:01 GMT".RFC822Date()
                    expect(feed.lastUpdated).to(equal(date))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Star City"))
                    expect(article.link).to(equal(NSURL(string: "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp")))
                    expect(article.description).to(equal("How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia's <a href=\"http://howe.iki.rssi.ru/GCTC/gctc_e.htm\">Star City</a>."))
                    let date = "Tue, 03 Jun 2003 09:39:21 GMT".RFC822Date()
                    expect(article.published).to(equal(date))
                    expect(article.guid).to(equal("http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"))
                }
                if let article = feed?.articles.last {
                    expect(article.title).to(beNil())
                    expect(article.link).to(beNil())
                    expect(article.description).to(equal("Sky watchers in Europe, Asia, and parts of Alaska and Canada will experience a <a href=\"http://science.nasa.gov/headlines/y2003/30may_solareclipse.htm\">partial eclipse of the Sun</a> on Saturday, May 31st."))
                    let date = "Fri, 30 May 2003 11:06:42 GMT".RFC822Date()
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
                    expect(feed.title).to(equal("dive into mark"))
                    expect(feed.description).to(equal("A <em>lot</em> of effort went into making this effortless"))
                    expect(feed.link).to(equal(NSURL(string: "http://example.org/feed.atom")))
                    let date = "2005-07-31T12:29:29Z".RFC3339Date()
                    expect(feed.lastUpdated).to(equal(date))
                    expect(feed.copyright).to(equal("Copyright (c) 2003, Mark Pilgrim"))
                    expect(feed.imageURL).to(equal(NSURL(string: "http://example.org/icon.gif")))
                }
            }

            it("should parse the feed's items") {
                expect(feed?.articles.count).to(equal(2))
                if let article = feed?.articles.first {
                    expect(article.title).to(equal("Atom draft-07 snapshot"))
                    expect(article.link).to(equal(NSURL(string: "http://example.org/2005/04/02/atom")))
                    expect(article.guid).to(equal("tag:example.org,2003:3.2397"))
                    let updated = "2005-07-31T12:29:29Z".RFC3339Date()
                    expect(article.updated).to(equal(updated))
                    let published = "2003-12-13T08:29:29-04:00".RFC3339Date()
                    expect(article.published).to(equal(published))
                    expect(article.content).to(equal("<div><p><i>[Update: The Atom draft is finished.]</i></p></div>"))
                    expect(article.enclosures.count).to(equal(1))
                    expect(article.authors.count).to(equal(2))
                    if let author = article.authors.first {
                        expect(author.name).to(equal("Mark Pilgrim"))
                        expect(author.email).to(equal(NSURL(string: "f8dy@example.com")))
                        expect(author.uri).to(equal(NSURL(string: "http://example.org")))
                    }
                    if let author = article.authors.last {
                        expect(author.name).to(equal("Sam Ruby"))
                        expect(author.email).to(beNil())
                        expect(author.uri).to(beNil())
                    }
                }
                if let article = feed?.articles.last {
                    // applying the default feed's authors to the feed.
                    expect(article.title).to(equal("Atom 2"))
                    expect(article.authors.count).to(equal(2))
                    if let author = article.authors.first {
                        expect(author.name).to(equal("Mark Pilgrim"))
                        expect(author.email).to(equal(NSURL(string: "f8dy@example.com")))
                        expect(author.uri).to(equal(NSURL(string: "http://example.org")))
                    }
                    if let author = article.authors.last {
                        expect(author.name).to(equal("Some Person"))
                        expect(author.email).to(beNil())
                        expect(author.uri).to(beNil())
                    }
                }
            }
        }
    }
}
