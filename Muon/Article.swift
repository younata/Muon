public class Article {
    public private(set) var title : String? = nil
    public private(set) var link : NSURL? = nil
    public private(set) var guid : String? = nil
    public private(set) var description : String? = nil
    public private(set) var published : NSDate? = nil
    public private(set) var updated : NSDate? = nil
    public private(set) var content : String? = nil

    public private(set) var enclosures : [Enclosure] = []
}