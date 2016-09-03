import XCTest
import Muon

func parserWithContentsOfFile(_ fileName: String) -> FeedParser {
    let location = Bundle(for: AtomPerformanceTest.self).path(forResource: fileName, ofType: nil)!
    let contents = try! String(contentsOfFile: location, encoding: String.Encoding.utf8)
    let parser = FeedParser(string: contents)
    return parser
}

class RSS1PerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("rss1_large.rss")
        self.measure {
            parser.main()
        }
    }
}

class RSS2PerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("rss2_large.rss")
        self.measure {
            parser.main()
        }
    }
}

class AtomPerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("atom_large.xml")
        self.measure {
            parser.main()
        }
    }
}
