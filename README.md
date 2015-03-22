MediumScrollFullScreen
====================

Medium's upper and lower menu in Scroll.

## Demo

![MediumScrollFullScreen](https://github.com/pixyzehn/MediumScrollFullScreen/blob/master/Assets/MediumScrollFullScreen.gif)

## Description

MediumScrollFullScreen is really similar to menu in scroll of real Medium for iOS.

In reference to [NJKScrollFullScreen](https://github.com/ninjinkun/NJKScrollFullScreen), I implemented MediumScrollFullScreen.

##Installation

1. The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

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

2. Delete status bar by editting info.plist.

Add "View controller-based status bar appearance", "Status bar is initially hidden" in your Information Property List. Each value of these key is "NO", "YES".

3. You have to make a change to a specific file. (In sample case, a specific file is WebViewController.swift.)

Refer to MediumScrollFullScreen-Sample project.

## Licence

[MIT](https://github.com/pixyzehn/MediumScrollFullScreen/blob/master/LICENSE)

## Author

[pixyzehn](https://github.com/pixyzehn)
