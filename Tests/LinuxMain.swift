import XCTest
import Quick
import Nimble

@testable import MuonTests

Quick.QCKMain([
        FeedParserSpec.self,
        IntegrationSpec.self,
        StringExtensionSpec.self,
    ],
    testCases: [
        testCase(FeedParserSpec.allTests),
        testCase(IntegrationSpec.allTests),
        testCase(StringExtensionSpec.allTests),
    ]
)
