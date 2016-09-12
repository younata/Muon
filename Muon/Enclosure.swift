import Foundation
public struct Enclosure {
    public let url : NSURL
    public let length : Int
    public let type : String

    public init(url: NSURL, length: Int, type: String) {
        self.url = url
        self.length = length
        self.type = type
    }
}
