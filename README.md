# KZWRouter

[![CI Status](https://img.shields.io/travis/ouyrp/KZWRouter.svg?style=flat)](https://travis-ci.org/ouyrp/KZWRouter)
[![Version](https://img.shields.io/cocoapods/v/KZWRouter.svg?style=flat)](https://cocoapods.org/pods/KZWRouter)
[![License](https://img.shields.io/cocoapods/l/KZWRouter.svg?style=flat)](https://cocoapods.org/pods/KZWRouter)
[![Platform](https://img.shields.io/cocoapods/p/KZWRouter.svg?style=flat)](https://cocoapods.org/pods/KZWRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KZWRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KZWRouter'
```

## 使用说明
调用open 方法参数url的格式为：targetName://actionName?urlString=https%3a%2f%2fwww.zhihu.com%2f
如果参数中有链接参数记得链接需要encode，如上，

如果带回调，不建议使用open方法，使用category直接对回调进行参数封装，使用例子在Demo中已经给了，有问题可以给我发邮件，看到就会处理


## Author

ouyrp,mooncoder@163.com

## License

KZWRouter is available under the MIT license. See the LICENSE file for more info.
