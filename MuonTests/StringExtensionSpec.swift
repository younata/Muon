import Quick
import Nimble
import Muon

class StringExtensionSpec: QuickSpec {
    override func spec() {

        describe("has only whitespace") {
            it("should return no if a string contains non-whitespace characters") {
                expect("a".hasOnlyWhitespace()).to(beFalsy())
            }

            it("should return yes for an empty string") {
                expect("".hasOnlyWhitespace()).to(beTruthy())
            }

            it("should return yes if a string only contains whitespace") {
                expect("\t\n ".hasOnlyWhitespace()).to(beTruthy())
            }
        }

        describe("Parsing RFC822 dates") {
            context("With a day") {
                context("with a listed timezone") {
                    it("parse a date with seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021846896.0)
                        expect("Sun, 19 May 2002 15:21:36 PDT".RFC822Date()).to(equal(date))
                    }

                    it("parse a date without seconds as 0 seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021846860.0)
                        expect("Sun, 19 May 2002 15:21 PDT".RFC822Date()).to(equal(date))
                    }
                }

                context("without a listed timezone") {
                    // assume GMT
                    it("parse a date with seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021821696.0)
                        expect("Sun, 19 May 2002 15:21:36".RFC822Date()).to(equal(date))
                    }

                    it("parse a date without seconds as 0 seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021821660.0)
                        expect("Sun, 19 May 2002 15:21".RFC822Date()).to(equal(date))
                    }
                }
            }

            context("Without a day") {
                context("with a listed timezone") {
                    it("parse a date with seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021846896.0)
                        expect("19 May 2002 15:21:36 PDT".RFC822Date()).to(equal(date))
                    }

                    it("parse a date without seconds as 0 seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021846860.0)
                        expect("19 May 2002 15:21 PDT".RFC822Date()).to(equal(date))
                    }
                }

                context("without a listed timezone") {
                    // assume GMT
                    it("parse a date with seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021821696.0)
                        expect("19 May 2002 15:21:36".RFC822Date()).to(equal(date))
                    }

                    it("parse a date without seconds as 0 seconds") {
                        let date = NSDate(timeIntervalSince1970: 1021821660.0)
                        expect("19 May 2002 15:21".RFC822Date()).to(equal(date))
                    }
                }
            }
        }

        describe("Parsing RFC3339 dates") {
            context("with a timezone") {
                it("parses the date") {
                    let date = NSDate(timeIntervalSince1970: 1021846896.0)
                    expect("2002-05-19T14:21:36-0800".RFC3339Date()).to(equal(date))
                }

                it("parses this weird other format") {
                    let date = NSDate(timeIntervalSince1970: 1021846896.36)
                    expect("2002-05-19T22:41:36.36+0020".RFC3339Date()).to(equal(date))

                }
            }

            context("without a timezone") {
                it("parse the date") {
                    // 1937-01-01T12:00:27
                    let date = NSDate(timeIntervalSince1970: 1021821696.0)
                    expect("2002-05-19T15:21:36".RFC3339Date()).to(equal(date))

                }
            }
        }

        describe("Escaping HTML strings") {
            it("should safely escape them") {
                let escaped = "&lt;hello world&gt; &quot;this&quot; &#39;is&#39; &amp; escaped"
                expect("<hello world> \"this\" 'is' & escaped".escapeHtml()).to(equal(escaped))
            }
        }
    }
}
