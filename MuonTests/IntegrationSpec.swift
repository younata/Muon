import Quick
import Nimble
import Muon

class IntegrationSpec: QuickSpec {
    override func spec() {
        var parser : FeedParser! = nil
        let formatter = NSDateFormatter()

        beforeEach {
            formatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss zzz"
        }

        describe("Atom") {
            var feed : Feed? = nil
            var parseError : NSError? = nil
            beforeEach {
                let expectation = self.expectationWithDescription("parsing")
                let researchKit = String(contentsOfFile: "researchkit.atom", encoding: NSUTF8StringEncoding, error: nil)!
                parser = FeedParser(string: researchKit)
                parser.success { feed = $0; expectation.fulfill() }
                parser.failure { parseError = $0; expectation.fulfill() }

                parser.parse()
                self.waitForExpectationsWithTimeout(10, handler: { _ in });
            }

            it("should parse the feed") {
                expect(feed).toNot(beNil())
                if let feed = feed {
                    expect(feed.title).to(equal("ResearchKit Blog - ResearchKit.org"))
                    expect(feed.link).to(equal(NSURL(string: "http://researchkit.org/blog.html")!))
                    expect(feed.description).to(equal("Get the latest news and helpful tips on ResearchKit."))
                    expect(feed.language).to(equal(NSLocale(localeIdentifier: "en-US")))
                    let buildDate = "Tue, 14 Apr 2015 10:00:00 PDT"
                    let date = formatter.dateFromString(buildDate)
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
                    let date = formatter.dateFromString(published)
                    expect(article.published).to(equal(date))
                    expect(article.enclosures.count).to(equal(0))
                }
            }
        }
    }
}
