import XCTest
import Foundation
@testable import Muon

class IntegrationTests: XCTestCase {
    private func readFeed(_ fileName: String) -> Feed? {
        var feed: Feed?
        let parser: FeedParser
        do {
            parser = try parserWithContentsOfFile(fileName)
        } catch let error {
            XCTFail("Unable to read file at \(fileName), got \(error)")
            return nil
        }

        let expectation = self.expectation(description: "Should have parsed feed")

        _ = parser.success {
            feed = $0
            expectation.fulfill()
        }
        _ = parser.failure { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        parser.main()

        self.waitForExpectations(timeout: 1, handler: nil)

        return feed
    }

    func testParsesResearchKit() {
        guard let feed = readFeed("researchkit.rss") else {
            return
        }

        // feed
        XCTAssertEqual(feed.title, "ResearchKit Blog - ResearchKit.org")
        XCTAssertEqual(feed.link, URL(string: "http://researchkit.org/blog.html")!)
        XCTAssertEqual(feed.description, "Get the latest news and helpful tips on ResearchKit.")
        XCTAssertEqual(feed.language, Locale(identifier: "en-US"))
        let buildDate = "Tue, 14 Apr 2015 10:00:00 PDT".RFC822Date()
        XCTAssertEqual(feed.lastUpdated, buildDate)
        XCTAssertEqual(feed.copyright, "Copyright 2015, Apple Inc.")

        // articles
        XCTAssertEqual(feed.articles.count, 1)
        guard let article = feed.articles.first else {
            return XCTFail("No articles found")
        }
        XCTAssertEqual(article.title, "Welcome to ResearchKit!")
        XCTAssertEqual(article.link, URL(string: "http://researchkit.org/blog.html#article-1"))
        XCTAssertEqual(article.guid, "http://researchkit.org/blog.html#article-1")
        XCTAssertEqual(article.description, " On March 9, Apple introduced the world to  ResearchKit , a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.  This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.  You can get started with ResearchKit by visiting  GitHub , now available to all developers for free under the ResearchKit BSD license. Be sure to check out the  Overview  tab for great links to  documentation  and  sample code  to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.  We can’t wait to see what we discover together!  - The ResearchKit Team ")
        // these two strings are equal, according to diff. Yet the equal matcher fails.
        XCTAssertEqual(article.content, "<p>On March 9, Apple introduced the world to <a href=\"http://www.apple.com/researchkit/\">ResearchKit</a>, a new software framework designed for health and medical research that helps doctors and scientists gather data more frequently and more accurately from participants using iPhone apps. Today, we’re excited to make ResearchKit available as open source so that researchers can more easily develop their own research apps and leverage the visual consent flows, real time dynamic active tasks and surveys that are included in the framework. Now that it’s available as open source, researchers all over the world will be able to contribute new modules to the framework, like activities around cognition or mood, and share them with the global research community to further advance what we know about disease.</p><p>This new blog will provide researchers and engineers all over the world with a simple forum for sharing tips on how to take advantage of the ResearchKit framework. It’s also a great place to check-in for news and updates from studies utilizing ResearchKit and hear from researchers directly about new studies and modules in development.</p><p>You can get started with ResearchKit by visiting <a href=\"https://github.com/ResearchKit/ResearchKit\">GitHub</a>, now available to all developers for free under the ResearchKit BSD license. Be sure to check out the <a href=\"index.html\">Overview</a> tab for great links to <a href=\"docs/docs/Overview/GuideOverview.html\">documentation</a> and <a href=\"https://github.com/ResearchKit/ResearchKit/tree/master/samples/ORKCatalog\">sample code</a> to help you start building your research app today. You can even share your favorite modules with the global research community by creating an issue or claiming an existing one from our issue list and send us a pull request.</p><p>We can’t wait to see what we discover together!</p><p>- The ResearchKit Team</p>")
        let published = "Tue, 14 Apr 2015 10:00:00 PDT".RFC822Date()
        XCTAssertEqual(article.published, published)
        XCTAssertEqual(article.enclosures.count, 0)
    }

    func testParsesSparkfun() {
        guard let feed = readFeed("sparkfun.rss") else {
            return
        }

        // feed
        XCTAssertEqual(feed.title, "SparkFun Electronics Blog Posts")
        XCTAssertEqual(feed.link, URL(string: "https://www.sparkfun.com/news")!)

        XCTAssertEqual(feed.articles.count, 20)
        guard let article = feed.articles.first else {
            return XCTFail("No articles found")
        }
        XCTAssertEqual(article.title, "Photon Kit contest winners")
        XCTAssertEqual(article.link, URL(string: "https://www.sparkfun.com/news/1910"))
        XCTAssertEqual(article.guid, "urn:uuid:b591fe6f-ed76-e46a-ffc0-66cac3fac399")
        XCTAssertEqual(article.description, "")
        let sparkfun1: String?
        do {
            sparkfun1 = try read(file: "sparkfun1.html")
        } catch let error {
            XCTFail("Got \(error) trying to read sparkfun1.html")
            sparkfun1 = nil
        }
        let loadedString = sparkfun1?.trimmingWhitespace()
        XCTAssertEqual(article.content, loadedString)
        let updated = "2015-08-25T08:43:06-06:00".RFC3339Date()
        XCTAssertNotNil(article.published)
        XCTAssertEqual(article.updated, updated)
        XCTAssertEqual(article.enclosures.count, 0)
    }

    func testParsesXKCD_atom() {
        guard let feed = readFeed("xkcd.atom") else {
            return
        }

        XCTAssertEqual(feed.title, "xkcd.com")
        XCTAssertEqual(feed.link, URL(string: "http://xkcd.com/")!)
        XCTAssertEqual(feed.lastUpdated, "2016-01-11T00:00:00Z".RFC3339Date())

        XCTAssertEqual(feed.articles.count, 4)
        guard let article = feed.articles.first else {
            return XCTFail("No articles found")
        }
        XCTAssertEqual(article.title, "Magnus")
        XCTAssertEqual(article.link, URL(string: "http://xkcd.com/1628/"))
        XCTAssertEqual(article.guid, "http://xkcd.com/1628/")
        XCTAssertEqual(article.description, "<img src=\"http://imgs.xkcd.com/comics/magnus.png\" title=\"In the latest round, 9-year-old Muhammad Ali beat 10-year-old JFK at air hockey, while Secretariat lost the hot-dog-eating crown to 12-year-old Ken Jennings. Meanwhile, in a huge upset, 11-year-old Martha Stewart knocked out the adult Ronda Rousey.\" alt=\"In the latest round, 9-year-old Muhammad Ali beat 10-year-old JFK at air hockey, while Secretariat lost the hot-dog-eating crown to 12-year-old Ken Jennings. Meanwhile, in a huge upset, 11-year-old Martha Stewart knocked out the adult Ronda Rousey.\" />")
        XCTAssertEqual(article.content, "")
        let updated = "2016-01-11T00:00:00Z".RFC3339Date()
        XCTAssertNotNil(article.published)
        XCTAssertEqual(article.updated, updated)
        XCTAssertEqual(article.enclosures.count, 0)
    }

    func testParsesXKCD_rss() {
        guard let feed = readFeed("xkcd.rss") else {
            return
        }

        XCTAssertEqual(feed.title, "xkcd.com")
        XCTAssertEqual(feed.link, URL(string: "http://xkcd.com/")!)
        XCTAssertEqual(feed.description, "xkcd.com: A webcomic of romance and math humor.")
        XCTAssertEqual(feed.language, Locale(identifier: "en"))

        XCTAssertEqual(feed.articles.count, 4)
        guard let article = feed.articles.first else {
            return XCTFail("No articles found")
        }

        XCTAssertEqual(article.title, "Magnus")
        XCTAssertEqual(article.link, URL(string: "http://xkcd.com/1628/"))
        XCTAssertEqual(article.guid, "http://xkcd.com/1628/")
        XCTAssertEqual(article.description, "<img src=\"http://imgs.xkcd.com/comics/magnus.png\" title=\"In the latest round, 9-year-old Muhammad Ali beat 10-year-old JFK at air hockey, while Secretariat lost the hot-dog-eating crown to 12-year-old Ken Jennings. Meanwhile, in a huge upset, 11-year-old Martha Stewart knocked out the adult Ronda Rousey.\" alt=\"In the latest round, 9-year-old Muhammad Ali beat 10-year-old JFK at air hockey, while Secretariat lost the hot-dog-eating crown to 12-year-old Ken Jennings. Meanwhile, in a huge upset, 11-year-old Martha Stewart knocked out the adult Ronda Rousey.\" />")
        XCTAssertEqual(article.content, "")
        let updated = "Mon, 11 Jan 2016 05:00:00 -0000".RFC822Date()
        XCTAssertEqual(article.published, updated)
        XCTAssertNil(article.updated)
        XCTAssertEqual(article.enclosures.count, 0)
    }

    func testParsesRSS_0_91() {
        guard let feed = readFeed("rss091.rss") else {
            return
        }

        XCTAssertEqual(feed.title, "WriteTheWeb")
        XCTAssertEqual(feed.link, URL(string: "http://writetheweb.com"))
        XCTAssertEqual(feed.description, "News for web users that write back")
        XCTAssertEqual(feed.language, Locale(identifier: "en-us"))
        XCTAssertEqual(feed.copyright, "Copyright 2000, WriteTheWeb team.")
        XCTAssertEqual(feed.imageURL, URL(string: "http://writetheweb.com/images/mynetscape88.gif"))

        XCTAssertEqual(feed.articles.count, 1)
        guard let article = feed.articles.first else {
            return XCTFail("No articles found")
        }

        XCTAssertEqual(article.title, "Giving the world a pluggable Gnutella")
        XCTAssertEqual(article.link, URL(string: "http://writetheweb.com/read.php?item=24"))
        XCTAssertEqual(article.description, "WorldOS is a framework on which to build programs that work like Freenet or Gnutella -allowing distributed applications using peer-to-peer routing.")
    }

    func testParsesRSS_0_92() {
        guard let feed = readFeed("rss092.rss") else {
            return
        }

        XCTAssertEqual(feed.title, "Dave Winer: Grateful Dead")
        XCTAssertEqual(feed.link, URL(string: "http://www.scripting.com/blog/categories/gratefulDead.html"))
        XCTAssertEqual(feed.description, "A high-fidelity Grateful Dead song every day. This is where we're experimenting with enclosures on RSS news items that download when you're not using your computer. If it works (it will) it will be the end of the Click-And-Wait multimedia experience on the Internet. ")
        let date = "Fri, 13 Apr 2001 19:23:02 GMT".RFC822Date()
        XCTAssertEqual(feed.lastUpdated, date)

        XCTAssertEqual(feed.articles.count, 2)
        if let article = feed.articles.first {
            XCTAssertEqual(article.description, "Moshe Weitzman says Shakedown Street is what I'm lookin for for tonight. I'm listening right now. It's one of my favorites. \"Don't tell me this town ain't got no heart.\" Too bright. I like the jazziness of Weather Report Suite. Dreamy and soft. How about The Other One? \"Spanish lady come to me..\"")
        } else {
            return XCTFail("No articles found")
        }

        if let article = feed.articles.last {
            XCTAssertEqual(article.description, "<a href=\"http://www.scripting.com/mp3s/youWinAgain.mp3\">The news is out</a>, all over town..<p>You've been seen, out runnin round. <p>The lyrics are <a href=\"http://www.cs.cmu.edu/~mleone/gdead/dead-lyrics/You_Win_Again.txt\">here</a>, short and sweet. <p><i>You win again!</i>")
            XCTAssertEqual(article.enclosures.count, 1)
            if let enclosure = article.enclosures.first {
                XCTAssertEqual(enclosure.url, URL(string: "http://www.scripting.com/mp3s/youWinAgain.mp3"))
                XCTAssertEqual(enclosure.length, 3874816)
                XCTAssertEqual(enclosure.type, "audio/mpeg")
            }
        } else {
            return XCTFail("No articles found")
        }
    }

    func testParsesRSS_1_0() {
        guard let feed = readFeed("rss100.rss") else {
            return
        }

        XCTAssertEqual(feed.title, "XML.com")
        XCTAssertEqual(feed.link, URL(string: "http://xml.com/pub"))
        XCTAssertEqual(feed.description.trimmingWhitespace(), "XML.com features a rich mix of information and services for the XML community.")
        XCTAssertEqual(feed.imageURL, URL(string: "http://xml.com/universal/images/xml_tiny.gif"))

        XCTAssertEqual(feed.articles.count, 2)
        if let article = feed.articles.first {
            XCTAssertEqual(article.title, "Processing Inclusions with XSLT")
            XCTAssertEqual(article.link, URL(string: "http://xml.com/pub/2000/08/09/xslt/xslt.html"))
            XCTAssertEqual(article.description, "Processing document inclusions with general XML tools can be problematic. This article proposes a way of preserving inclusion information through SAX-based processing.")
        } else {
            return XCTFail("No articles found")
        }
        if let article = feed.articles.last {
            XCTAssertEqual(article.title, "Putting RDF to Work")
            XCTAssertEqual(article.link, URL(string: "http://xml.com/pub/2000/08/09/rdfdb/index.html"))
            XCTAssertEqual(article.description, "Tool and API support for the Resource Description Framework is slowly coming of age. Edd Dumbill takes a look at RDFDB, one of the most exciting new RDF toolkits.")
        } else {
            return XCTFail("No articles found")
        }
    }

    func testParsesRSS_2_0() {
        guard let feed = readFeed("rss200.rss") else {
            return
        }

        XCTAssertEqual(feed.title, "Liftoff News")
        XCTAssertEqual(feed.link, URL(string: "http://liftoff.msfc.nasa.gov/"))
        XCTAssertEqual(feed.description, "Liftoff to Space Exploration.")
        XCTAssertEqual(feed.language, Locale(identifier: "en-us"))
        let date = "Tue, 10 Jun 2003 09:41:01 GMT".RFC822Date()
        XCTAssertEqual(feed.lastUpdated, date)

        XCTAssertEqual(feed.articles.count, 2)
        if let article = feed.articles.first {
            XCTAssertEqual(article.title, "Star City")
            XCTAssertEqual(article.link, URL(string: "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"))
            XCTAssertEqual(article.description, "How do Americans get ready to work with Russians aboard the International Space Station? They take a crash course in culture, language and protocol at Russia's <a href=\"http://howe.iki.rssi.ru/GCTC/gctc_e.htm\">Star City</a>.")
            let date = "Tue, 03 Jun 2003 09:39:21 GMT".RFC822Date()
            XCTAssertEqual(article.published, date)
            XCTAssertEqual(article.guid, "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573")
        }
        if let article = feed.articles.last {
            XCTAssertEqual(article.title, "")
            XCTAssertNil(article.link)
            XCTAssertEqual(article.description, "Sky watchers in Europe, Asia, and parts of Alaska and Canada will experience a <a href=\"http://science.nasa.gov/headlines/y2003/30may_solareclipse.htm\">partial eclipse of the Sun</a> on Saturday, May 31st.")
            let date = "Fri, 30 May 2003 11:06:42 GMT".RFC822Date()
            XCTAssertEqual(article.published, date)
            XCTAssertEqual(article.guid, "http://liftoff.msfc.nasa.gov/2003/05/30.html#item572")
        }
    }

    func testParsesAtom_1_0() {
        guard let feed = readFeed("atom100.xml") else {
            return
        }

        XCTAssertEqual(feed.title, "dive into mark")
        XCTAssertEqual(feed.description, "A <em>lot</em> of effort went into making this effortless")
        XCTAssertEqual(feed.link, URL(string: "http://example.org/feed.atom"))
        XCTAssertEqual(feed.lastUpdated, "2005-07-31T12:29:29Z".RFC3339Date())
        XCTAssertEqual(feed.copyright, "Copyright (c) 2003, Mark Pilgrim")
        XCTAssertEqual(feed.imageURL, URL(string: "http://example.org/icon.gif"))

        XCTAssertEqual(feed.articles.count, 2)
        if let article = feed.articles.first {
            XCTAssertEqual(article.title, "Atom draft-07 snapshot")
            XCTAssertEqual(article.link, URL(string: "http://example.org/2005/04/02/atom"))
            XCTAssertEqual(article.guid, "tag:example.org,2003:3.2397")
            XCTAssertEqual(article.updated, "2005-07-31T12:29:29Z".RFC3339Date())
            XCTAssertEqual(article.published, "2003-12-13T08:29:29-04:00".RFC3339Date())
            XCTAssertEqual(article.content, "<div><p><i>[Update: The Atom draft is finished.]</i></p></div>")
            XCTAssertEqual(article.enclosures.count, 1)
            XCTAssertEqual(article.authors.count, 2)
            if let author = article.authors.first {
                XCTAssertEqual(author.name, "Mark Pilgrim")
                XCTAssertEqual(author.email, URL(string: "f8dy@example.com"))
                XCTAssertEqual(author.uri, URL(string: "http://example.org"))
            }
            if let author = article.authors.last {
                XCTAssertEqual(author.name, "Sam Ruby")
                XCTAssertNil(author.email)
                XCTAssertNil(author.uri)
            }
        }
        if let article = feed.articles.last {
            // applying the default feed's authors to the feed.
            XCTAssertEqual(article.title, "Atom 2")
            XCTAssertEqual(article.authors.count, 2)
            if let author = article.authors.first {
                XCTAssertEqual(author.name, "Mark Pilgrim")
                XCTAssertEqual(author.email, URL(string: "f8dy@example.com"))
                XCTAssertEqual(author.uri, URL(string: "http://example.org"))
            }
            if let author = article.authors.last {
                XCTAssertEqual(author.name, "Some Person")
                XCTAssertNil(author.email)
                XCTAssertNil(author.uri)
            }
        }
    }
}
