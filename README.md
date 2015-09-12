##Muon

RSS/Atom parser written in swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

###Usage

```swift
import Muon

let myRSSFeed = String(contentsOfURL: "https://example.com/feed.rss", encoding: NSUTF8StringEncoding)
let parser = FeedParser(string: myRSSFeed)

parser.success {
    print("Parsed: \($0)")
}
parser.failure {
    print("Failed to parse: \($0)")
}

parser.main() // or add to an NSOperationQueue
```

###Installing

####Carthage

Swift 2.0:

* add `github "younata/Muon"`

Swift 1.2:

* add `github "younata/Muon" "0.3.1"`

####Cocoapods

Make sure that `user_frameworks!` is defined in your Podfile

Swift 2.0:

* add `Pod "Muon" :git => "https://github.com/younata/Muon.git"`

Swift 1.2:

* add `Pod "Muon" :git => "https://github.com/younata/Muon.git", :tag => "v0.3.1"`

###ChangeLog

#### 0.4.0

- Swift 2.0 Compatibility
- Enabled for use in extensions
- Not obj-c compatible anymore (sorry)
- Less strict on parsing feeds
- Enabled bitcode

#### 0.3.1

- Last Swift 1.2 release

#### 0.3.0

- Add objc support
- Enable whole module optimization

#### 0.2.0

- Make FeedParser more injector-friendly

#### 0.1.1

- Makes Public initializers for Feed and Article

#### 0.1.0

- Initial support for RSS 1.0, RSS 2.0, and Atom feeds

### License

[MIT](LICENSE)
