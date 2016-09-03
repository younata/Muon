import Foundation
public struct Enclosure {
    public let url : URL
    public let length : Int
    public let type : String

    public init(url: URL, length: Int, type: String) {
        self.url = url
        self.length = length
        self.type = type
    }
}
