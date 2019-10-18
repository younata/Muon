import XCTest

extension FeedParserTests {
    static let __allTests = [
        ("testInitializingWithEmptyString", testInitializingWithEmptyString),
        ("testInitializingWithAFeedSucceeds", testInitializingWithAFeedSucceeds),
        ("testInitializingWithoutData_ImmediatelyFailsIfMainCalledWithoutConfiguring", testInitializingWithoutData_ImmediatelyFailsIfMainCalledWithoutConfiguring),
        ("testInitializingWithoutData_SucceedsIfMainCalledAfterConfiguring", testInitializingWithoutData_SucceedsIfMainCalledAfterConfiguring),
    ]
}

extension IntegrationTests {
    static let __allTests = [
        ("testParsesResearchKit", testParsesResearchKit),
        ("testParsesSparkfun", testParsesSparkfun),
        ("testParsesXKCD_atom", testParsesXKCD_atom),
        ("testParsesXKCD_rss", testParsesXKCD_rss),
        ("testParsesRSS_0_91", testParsesRSS_0_91),
        ("testParsesRSS_0_92", testParsesRSS_0_92),
        ("testParsesRSS_1_0", testParsesRSS_1_0),
        ("testParsesRSS_2_0", testParsesRSS_2_0),
        ("testParsesAtom_1_0", testParsesAtom_1_0),
    ]
}

extension AtomPerformanceTest {
    static let __allTests = [
        ("testPerformance", testPerformance)
    ]
}

extension RSS1PerformanceTest {
    static let __allTests = [
        ("testPerformance", testPerformance)
    ]
}

extension RSS2PerformanceTest {
    static let __allTests = [
        ("testPerformance", testPerformance)
    ]
}

extension StringExtensionTests {
    static let __allTests = [
        ("testOnlyWhitespace", testOnlyWhitespace),
        ("testParsingRFC822Dates", testParsingRFC822Dates),
        ("testParsingRFC3339Dates", testParsingRFC3339Dates),
        ("testEscapingHTMLStrings", testEscapingHTMLStrings),
    ]
}


#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(FeedParserTests.__allTests),
        testCase(IntegrationTests.__allTests),
        testCase(RSS1PerformanceTest.__allTests),
        testCase(RSS2PerformanceTest.__allTests),
        testCase(AtomPerformanceTest.__allTests),
        testCase(StringExtensionTests.__allTests),
    ]
}
#endif
