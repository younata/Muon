# Muon

RSS/Atom parser written in swift.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://ci.younata.com/api/v1/pipelines/other/jobs/muon-tests/badge)](https://ci.younata.com/teams/main/pipelines/other/jobs/muon-tests)

### Usage

```swift
import Muon

let myRSSFeed = try! String(contentsOf: URL(string: "https://example.com/feed.rss")!)
let parser = FeedParser(string: myRSSFeed)

parser.success {
    print("Parsed: \($0)")
}
parser.failure {
    print("Failed to parse: \($0)")
}

parser.main() // or add to an OperationQueue
```

## Installing

### Carthage

* add `github "younata/Muon" "1.0"

### Cocoapods

Make sure that `use_frameworks!` is defined in your Podfile

* add `pod "Muon", :git => "https://github.com/younata/Muon.git"`

## ChangeLog

### 1.0.0

- Drop support for swift < 5.0
- String extensions are no longer public.

### 0.9.0

- Drop support for swift < 4.0
- Clean up internal representations based off much newer swift features (this codebase predates swift 1.0!)
- Better handle how FeedParserError handles other error types.

### 0.7.0

- Swift 4.0 is supported
- FeedParser now guarantees that errors will always be of type `FeedParserError` (non-FeedParserErrors will be (poorly) wrapped in a `FeedParserError`).

### 0.6.0

- Swift 3.0
- Model objects now import Foundation

### 0.5.0

- Make Muon models (Feed, Article, Author, Enclosure) into structs
- Articles now have mostly non-optional properties (going away from the pure RSS/Atom specs to be more opinionated).

### 0.4.0

- Swift 2.0 Compatibility
- Enabled for use in extensions
- Not obj-c compatible anymore (sorry)
- Less strict on parsing feeds
- Enabled bitcode

### 0.3.1

- Last Swift 1.2 release

### 0.3.0

- Add objc support
- Enable whole module optimization

### 0.2.0

- Make FeedParser more injector-friendly

### 0.1.1

- Makes Public initializers for Feed and Article

### 0.1.0

- Initial support for RSS 1.0, RSS 2.0, and Atom feeds

## License

[MIT](LICENSE)
