public class Feed {
    public private(set) var title : String? = nil
    public private(set) var link : NSURL? = nil
    public private(set) var description : String? = nil
    public private(set) var language : NSLocale? = nil
    public private(set) var lastUpdated : NSDate? = nil
    public private(set) var copyright : String? = nil

    public private(set) var imageURL : NSURL? = nil

    public private(set) var articles : [Article] = []
}