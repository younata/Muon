import XCTest
import Foundation
import Nimble
import Muon

class RSS1PerformanceTest: XCTestCase {
    func testPerformance() {
        guard let parser = parserWithContentsOfFile("rss1_large.rss") else {
            fail("Unable to test")
            return
        }
        self.measure {
            parser.main()
        }
    }
}

class RSS2PerformanceTest: XCTestCase {
    func testPerformance() {
        guard let parser = parserWithContentsOfFile("rss2_large.rss") else {
            fail("Unable to test")
            return
        }
        self.measure {
            parser.main()
        }
    }
}

class AtomPerformanceTest: XCTestCase {
    func testPerformance() {
        guard let parser = parserWithContentsOfFile("atom_large.xml") else {
            fail("Unable to test")
            return
        }
        self.measure {
            parser.main()
        }
    }
}
