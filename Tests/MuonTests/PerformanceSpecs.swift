import XCTest
import Foundation
import Nimble
import Muon

class RSS1PerformanceTest: XCTestCase {
    func testPerformance() {
        guard let parser = (try? parserWithContentsOfFile("rss1_large.rss")) ?? nil else {
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
        guard let parser = (try? parserWithContentsOfFile("rss2_large.rss")) ?? nil else {
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
        guard let parser = (try? parserWithContentsOfFile("atom_large.xml")) ?? nil else {
            fail("Unable to test")
            return
        }
        self.measure {
            parser.main()
        }
    }
}
