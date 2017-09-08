Percoffee
====

Coffee info application.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Credits](#credits)

## Description

Application that can download from server and represent list of coffee articles.

## Features

- Networking service build on top of [Alamofire](https://github.com/Alamofire/Alamofire) wrapped with [Moya](https://github.com/Moya/Moya)
- Data model mapping implemented with native Swift 4 `Codable` feature
- Most UI layout was made with `UIStackView`
- Time zones of all dates received from server considered UTC
- Data update available with native pull-to-refresh UI
- Table cell resizing deferred to prevent UI glitch while downloading images
- Image downloading and caching build with [AlamofireImage](https://github.com/Alamofire/AlamofireImage)

## Requirements

- iOS 10.3+
- Xcode 9.0+
- Swift 4.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To switch default build system run:

```bash
$ sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer
```

Run `carthage bootstrap` to check out and build the project's dependencies.

## Credits

[Andrey Vyazovoy](https://linkedin.com/in/vyazovoy/)
