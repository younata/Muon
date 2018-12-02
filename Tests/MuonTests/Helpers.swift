import Foundation
import Muon
import Nimble

func parserWithContentsOfFile(_ fileName: String) throws -> FeedParser {
    do {
        return FeedParser(string: try read(file: fileName))
    } catch let error {
        throw error
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
    #if SWIFT_PACKAGE
        fileLocation = FileManager.default.currentDirectoryPath + "/Tests/MuonTests/" + file
    #else
        #if !os(Linux)
            guard let location = Bundle(for: AtomPerformanceTest.classForCoder()).path(forResource: file, ofType: nil) else {
                throw TestError.fileNotFound(file)
            }
            fileLocation = location
        #else
            throw TestError.osNotSupported
        #endif
    #endif
    guard FileManager.default.fileExists(atPath: fileLocation) else {
        throw TestError.fileNotFound(fileLocation)
    }
    return try String(contentsOfFile: fileLocation, encoding: String.Encoding.utf8)
}
