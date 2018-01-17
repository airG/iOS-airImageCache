# airImageCache

[![Documentation](https://raw.githubusercontent.com/airG/iOS-airImageCache/master/docs/badge.svg?sanitize=true)](https://airg.github.io/iOS-airImageCache/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

An extremely simple UIImage cache manager backed by both an in-memory NSCache and file system /Caches folder.

## Installation
Installation is best managed using Carthage. Add `github "airg/iOS-airImageCache"` to your cartfile and run `carthage install`, see [Carthage Installation Guide](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

You can also use Cocoapods to install. Add `pod 'airImageCache'` to your podfile.

## How to use airImageCache

On `AirImageCache` call `image(for: key, completion: (UIImage?) -> Void)`. There is no guarantee how long it will take to have the completion called, since you may be loading the image out of memory, off the disk or from the server. This returns a `URLSessionDataTask?`, which can be cancelled if you want to stop the server load.

To load images off a server, provide an object conforming to `AirImageURLProviding`, which only need to implement `func url(for key: String) -> URL?`.

This framework also provides an extension on `UIImageView`, to conveniently load and set the image, or cancel the download task associated with the image view.

## Documentation

Check out the [documentation](https://airg.github.io/iOS-airImageCache/). All calls should also be documented in the generated Swift interface.


## How it's made

airImageCache is currently written in Swift 4 with Xcode 9.2.

Documentation is generated using [Jazzy](https://github.com/realm/jazzy), a very useful tool for generating pretty docs.


## Contributing

Before opening a pull request, be sure to run `jazzy` to regenerate the docs.

