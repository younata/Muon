import Foundation

//private let dateFormatter = NSDateFormatter()

public extension String {
    public func hasOnlyWhitespace() -> Bool {
        return rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) == nil
    }

    public func RFC822Date() -> Date? {

        // Process
        var date : Date? = nil
        let str = uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let dateFromFormat : (String) -> Date? = {formatString in
            dateFormatter.dateFormat = formatString
            return dateFormatter.date(from: str)
        }

        if str.range(of: ",") != nil {
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

    public func RFC3339Date() -> Date? {
        var date : Date? = nil
        let str = uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "Z", with: "-0000")

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale!

        let dateFromFormat : (String) -> Date? = {formatString in
            dateFormatter.dateFormat = formatString
            return dateFormatter.date(from: str)
        }

        date = dateFromFormat("yyyy'-'MM'-'dd'T'HH':'mm':'sszzz")
        if date == nil { date = dateFromFormat("yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSzzz") }
        if date == nil { date = dateFromFormat("yyyy'-'MM'-'dd'T'HH':'mm':'ss") }
        return date
    }

    public func escapeHtml() -> String{
        var result = replacingOccurrences(of: "&", with: "&amp;")
        result = result.replacingOccurrences(of: "\"", with: "&quot;")
        result = result.replacingOccurrences(of: "'", with: "&#39;")
        result = result.replacingOccurrences(of: "<", with: "&lt;")
        return result.replacingOccurrences(of: ">", with: "&gt;")
    }
}
