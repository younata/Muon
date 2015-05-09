import Quick
import Nimble
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
                let expectation = self.expectationWithDescription("errorShouldBeCalled")
                subject.failure {error in
                    expect(error.localizedDescription).to(equal("No Feed Found"))
                    expectation.fulfill()
                }
                subject.main()
                self.waitForExpectationsWithTimeout(1, handler: { _ in })
            }
        }

        describe("Initializing a feedparser with a feed") {
            beforeEach {
                subject = FeedParser(string: feed)
            }

            it("should succeed when main is called") {
                let expectation = self.expectationWithDescription("should pass")
                subject.success {feed in
                    expectation.fulfill()
                }
                subject.failure {_ in
                    expect(true).to(beFalsy())
                }
                subject.main()
                self.waitForExpectationsWithTimeout(1, handler: { _ in })
            }
        }

        describe("Initializing a feedparser without data") {
            beforeEach {
                subject = FeedParser()
            }

            it("immediately call onFailure if main is called") {
                let expectation = self.expectationWithDescription("errorShouldBeCalled")
                subject.failure {error in
                    expect(error.localizedDescription).to(equal("Must be configured with data"))
                    expectation.fulfill()
                }
                subject.main()
                self.waitForExpectationsWithTimeout(1, handler: { _ in })
            }

            describe("after configuring") {
                beforeEach {
                    subject.configureWithString(feed)
                }

                it("should succeed when main is called") {
                    let expectation = self.expectationWithDescription("should pass")
                    subject.success {feed in
                        expectation.fulfill()
                    }
                    subject.failure {_ in
                        expect(true).to(beFalsy())
                    }
                    subject.main()
                    self.waitForExpectationsWithTimeout(1, handler: { _ in })
                }
            }
        }
    }
}
