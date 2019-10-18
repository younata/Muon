import Foundation
import Muon

func parserWithContentsOfFile(_ fileName: String) throws -> FeedParser {
    do {
        return FeedParser(string: try read(file: fileName))
    } catch let error {
        throw error
    }
}

extension String {
    func trimmingWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

enum TestError: Error {
    case fileNotFound(String)
    case osNotSupported

    var localizedDescription: String {
        switch self {
        case .fileNotFound(let location):
            return "Could not find file at \(location)"
        case .osNotSupported:
            return "This test does not support the current OS"
        }
    }
}

func read(file: String) throws -> String {
    let fileLocation: String
    #if os(Linux)
        fileLocation = FileManager.default.currentDirectoryPath + "/Tests/MuonTests/" + file
    #else
        if let location = Bundle(for: AtomPerformanceTest.classForCoder()).path(forResource: file, ofType: nil) {
            fileLocation = location
        } else {
            fileLocation = FileManager.default.currentDirectoryPath + "/Tests/MuonTests/" + file
        }
    #endif
    guard FileManager.default.fileExists(atPath: fileLocation) else {
        throw TestError.fileNotFound(fileLocation)
    }
    return try String(contentsOfFile: fileLocation, encoding: String.Encoding.utf8)
}
