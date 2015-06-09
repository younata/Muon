import XCTest
import Muon

func parserWithContentsOfFile(fileName: String) -> FeedParser {
    let location = NSBundle(forClass: AtomPerformanceTest.self).pathForResource(fileName, ofType: nil)!
    let contents = try! String(contentsOfFile: location, encoding: NSUTF8StringEncoding)
    let parser = FeedParser(string: contents)
    return parser
}

class RSS1PerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("rss1_large.rss")
        self.measureBlock {
            parser.main()
        }
    }
}

class RSS2PerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("rss2_large.rss")
        self.measureBlock {
            parser.main()
        }
    }
}

class AtomPerformanceTest: XCTestCase {
    func testPerformance() {
        let parser = parserWithContentsOfFile("atom_large.xml")
        self.measureBlock {
            parser.main()
        }
    }
}