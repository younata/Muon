import XCTest
import Foundation
@testable import Muon


class StringExtensionTests: XCTestCase {
    func testOnlyWhitespace() {
        XCTAssertFalse("a".hasOnlyWhitespace())
        XCTAssertTrue("".hasOnlyWhitespace())
        XCTAssertTrue("\t\n ".hasOnlyWhitespace())
    }

    func testParsingRFC822Dates() {
        // Day, timezone, with seconds
        XCTAssertEqual("Sun, 19 May 2002 15:21:36 PDT".RFC822Date(), Date(timeIntervalSince1970: 1021846896.0))

        // Day, timezone, no seconds - assumes 0 seconds.
        XCTAssertEqual("Sun, 19 May 2002 15:21 PDT".RFC822Date(), Date(timeIntervalSince1970: 1021846860.0))

        // day, no timezone, assums GMT
        XCTAssertEqual("Sun, 19 May 2002 15:21:36".RFC822Date(), Date(timeIntervalSince1970: 1021821696.0))
        XCTAssertEqual("Sun, 19 May 2002 15:21".RFC822Date(), Date(timeIntervalSince1970: 1021821660.0))

        // No day, still works.
        XCTAssertEqual("19 May 2002 15:21:36 PDT".RFC822Date(), Date(timeIntervalSince1970: 1021846896.0))
        XCTAssertEqual("19 May 2002 15:21 PDT".RFC822Date(), Date(timeIntervalSince1970: 1021846860.0))

        // No day, no timezone
        XCTAssertEqual("19 May 2002 15:21:36".RFC822Date(), Date(timeIntervalSince1970: 1021821696.0))
        XCTAssertEqual("19 May 2002 15:21".RFC822Date(), Date(timeIntervalSince1970: 1021821660.0))
    }

    func testParsingRFC3339Dates() {
        // timezone
        XCTAssertEqual("2002-05-19T14:21:36-0800".RFC3339Date(), Date(timeIntervalSince1970: 1021846896.0))
        XCTAssertEqual("2002-05-19T22:41:36.36+0020".RFC3339Date(), Date(timeIntervalSince1970: 1021846896.36))

        // no timezone
        XCTAssertEqual("2002-05-19T15:21:36".RFC3339Date(), Date(timeIntervalSince1970: 1021821696.0))
    }

    func testEscapingHTMLStrings() {
        XCTAssertEqual(
            "<hello world> \"this\" 'is' & escaped".escapeHtml(),
            "&lt;hello world&gt; &quot;this&quot; &#39;is&#39; &amp; escaped"
        )
    }
}
