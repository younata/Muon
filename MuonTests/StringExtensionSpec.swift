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

        describe("Parsing dates") {
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
    }
}
