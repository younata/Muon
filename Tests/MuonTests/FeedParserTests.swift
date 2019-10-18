import XCTest
import Foundation
import Muon

class FeedParserTests: XCTestCase {
    func testInitializingWithEmptyString() {
        let parser = FeedParser(string: "")
        let expectation = self.expectation(description: "errorShouldBeCalled")
        _ = parser.failure { error in
            XCTAssertEqual(error, FeedParserError.noFeed)
            expectation.fulfill()
        }
        parser.main()
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testInitializingWithAFeedSucceeds() {
        let parser = FeedParser(string: "<rss><channel></channel></rss>")
        let expectation = self.expectation(description: "successShouldBeCalled")
        _ = parser.success { feed in
            XCTAssertNotNil(feed)
            expectation.fulfill()
        }
        _ = parser.failure { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        parser.main()
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testInitializingWithoutData_ImmediatelyFailsIfMainCalledWithoutConfiguring() {
        let parser = FeedParser()
        let expectation = self.expectation(description: "errorShouldBeCalled")
        _ = parser.success { feed in
            XCTAssertNil(feed)
            expectation.fulfill()
        }
        _ = parser.failure { error in
            XCTAssertEqual(error, FeedParserError.noData)
            expectation.fulfill()
        }
        parser.main()
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testInitializingWithoutData_SucceedsIfMainCalledAfterConfiguring() {
        let parser = FeedParser()
        let expectation = self.expectation(description: "successShouldBeCalled")
        _ = parser.success { feed in
            XCTAssertNotNil(feed)
            expectation.fulfill()
        }
        _ = parser.failure { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        parser.configureWithString("<rss><channel></channel></rss>")

        parser.main()
        self.waitForExpectations(timeout: 1, handler: nil)
    }
}
