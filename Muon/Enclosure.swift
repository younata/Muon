@objc public class Enclosure {
    @objc public let url : NSURL
    @objc public let length : Int
    @objc public let type : String

    @objc public init(url: NSURL, length: Int, type: String) {
        self.url = url
        self.length = length
        self.type = type
    }
}
