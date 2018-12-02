import Quick
import Nimble
import Foundation
import Muon

let feed = "<rss><channel></channel></rss>"

class FeedParserSpec: QuickSpec {
    override func spec() {
        var subject : FeedParser! = nil

        describe("Initializing a feedparser with empty string") {
            beforeEach {
                subject = FeedParser(string: "")
            }

            it("call onFailure if main is called") {
                let expectation = self.expectation(description: "errorShouldBeCalled")
                _ = subject.failure {error in
                    expect(error).to(equal(FeedParserError.noFeed))
                    expectation.fulfill()
                }
                subject.main()
                self.waitForExpectations(timeout: 1, handler: { _ in })
            }
        }

        describe("Initializing a feedparser with a feed") {
            beforeEach {
                subject = FeedParser(string: feed)
            }

            it("should succeed when main is called") {
                var feed: Feed? = nil
                _ = subject.success { feed = $0 }
                subject.main()
                expect(feed).toEventuallyNot(beNil())
            }
        }

        describe("Initializing a feedparser without data") {
            beforeEach {
                subject = FeedParser()
            }

            it("immediately call onFailure if main is called") {
                var error: Error? = nil
                _ = subject.failure { error = $0 }
                subject.main()
                expect(error).toNot(beNil())
                expect(error as? FeedParserError).to(equal(FeedParserError.noData))
            }

            describe("after configuring") {
                beforeEach {
                    subject.configureWithString(feed)
                }

                it("should succeed when main is called") {
                    var feed: Feed? = nil
                    _ = subject.success { feed = $0 }
                    subject.main()
                    expect(feed).toEventuallyNot(beNil())
                }
            }
        }
    }
}
