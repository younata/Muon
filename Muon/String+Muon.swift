import Foundation

//private let dateFormatter = NSDateFormatter()

public extension String {
    public func hasOnlyWhitespace() -> Bool {
        return rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet) == nil
    }

    public func RFC822Date() -> NSDate? {

        // Process
        var date : NSDate? = nil
        let str = uppercaseString

        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)

        var dateFromFormat : (String) -> NSDate? = {formatString in
            dateFormatter.dateFormat = formatString
            return dateFormatter.dateFromString(str)
        }

        if str.rangeOfString(",") != nil {
            // Sun, 19 May 2002 15:21:36 PDT
            date = dateFromFormat("EEE, dd MMM yyyy HH:mm:ss zzz")
            // Sun, 19 May 2002 15:21 PDT
            if date == nil { date = dateFromFormat("EEE, dd MMM yyyy HH:mm zzz") }
            // Sun, 19 May 2002 15:21:36
            if date == nil { date = dateFromFormat("EEE, dd MMM yyyy HH:mm:ss") }
            // Sun, 19 May 2002 15:21
            if date == nil { date = dateFromFormat("EEE, dd MMM yyyy HH:mm") }
        } else {
            // 19 May 2002 15:21:36 GMT
            date = dateFromFormat("dd MMM yyyy HH:mm:ss zzz")
            // 19 May 2002 15:21 GMT
            if date == nil { date = dateFromFormat("dd MMM yyyy HH:mm zzz") }
            // 19 May 2002 15:21:36
            if date == nil { date = dateFromFormat("dd MMM yyyy HH:mm:ss") }
            // 19 May 2002 15:21
            if date == nil { date = dateFromFormat("dd MMM yyyy HH:mm") }
        }
        return date
    }
}