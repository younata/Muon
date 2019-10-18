import XCTest
import Foundation
import Muon

class RSS1PerformanceTest: XCTestCase {
    func testPerformance() {
        guard let parser = (try? parserWithContentsOfFile("rss1_large.rss")) ?? nil else {
            XCTFail("Unable to test")
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
            XCTFail("Unable to test")
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
            XCTFail("Unable to test")
            return
        }
        self.measure {
            parser.main()
        }
    }
}
