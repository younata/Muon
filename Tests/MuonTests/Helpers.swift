import Foundation
import Muon

func parserWithContentsOfFile(_ fileName: String) -> FeedParser? {
    guard let contents = read(file: fileName) else {
        return nil
    }
    let parser = FeedParser(string: contents)
    return parser
}

func read(file: String) -> String? {
    let fileLocation: String
    #if swiftpm
        fileLocation = FileManager.default.currentDirectoryPath + "/Tests/MuonTests/" + file
    #else
        #if !os(Linux)
        guard let location = Bundle(for: AtomPerformanceTest.classForCoder()).path(forResource: file, ofType: nil) else {
            return nil
        }
        fileLocation = location
        #else
            return nil
        #endif
    #endif
    do {
        let contents = try String(contentsOfFile: fileLocation, encoding: String.Encoding.utf8)
        return contents
    } catch (let exception) {
        print("Error: \(exception)")
        return nil
    }
}
