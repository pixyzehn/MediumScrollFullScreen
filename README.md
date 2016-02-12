MediumScrollFullScreen
====================

Medium's upper and lower menu in Scroll.

## Demo

![MediumScrollFullScreen](https://github.com/pixyzehn/MediumScrollFullScreen/blob/master/Assets/MediumScrollFullScreen.gif)

## Description

MediumScrollFullScreen is really similar to menu in scroll of real Medium for iOS.

In reference to [NJKScrollFullScreen](https://github.com/ninjinkun/NJKScrollFullScreen), I implemented MediumScrollFullScreen.

##Installation

###CocoaPods


The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!
# The following is a Library of Swift.
pod 'MediumScrollFullScreen'
```

Then, run the following command:

```ruby
pod install
```

###Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate MediumScrollFullScreen into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "pixyzehn/MediumScrollFullScreen"
```

Run `carthage update`.

```bash
$ carthage update
```
###Other

Add the MediumScrollFullScreen (including MediumScrollFullScreen.swift) folder into your project.

---

Delete status bar by editting info.plist.

Add "View controller-based status bar appearance", "Status bar is initially hidden" in your Information Property List. Each value of these key is "NO", "YES".

You have to make a change to a specific file.
(In sample case, a specific file is WebViewController.swift.)

Refer to MediumScrollFullScreen-Sample project.

## Licence

[MIT](https://github.com/pixyzehn/MediumScrollFullScreen/blob/master/LICENSE)

## Author

[pixyzehn](https://github.com/pixyzehn)
