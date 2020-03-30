# TimeTable

[![build status](https://git.railwaymen.org/open-source/timetable-ios/badges/develop/pipeline.svg)](http://git.railwaymen.org/open-source/timetable-ios/commits/develop) [![coverage report](https://git.railwaymen.org/open-source/timetable-ios/badges/develop/coverage.svg)](http://git.railwaymen.org/open-source/timetable-ios/commits/develop)

## Description

Simple time tracking iOS application. Check out our [TimeTable Ruby on Rails project](https://github.com/railwaymen/timetable)!

## Requirements

- [Bundler](https://bundler.io) 2.1.4
- [Xcode](https://developer.apple.com/xcode/) 11.3.1

## Installation

- `bundler install`
- `bundle exec pod install`
- Open `*.xcworkspace` in Xcode

## Unit tests

- `bundle exec fastlane test`

## Fastlane

[Details about available lanes](fastlane/README.md)

## Swiftlint

[Swift lint rules](.swiftlint.yml)

## Git Hooks

- Pre-commit installation - `sh runScript.sh`

## Dependencies

### Cocoapods

- [CoordinatorsFoundation](https://git.railwaymen.org/open/coordinatorsfoundation) 0.2.2
- [Firebase](https://cocoapods.org/pods/Firebase) 6.21.0
- [JSONFactorable](https://git.railwaymen.org/open/jsonfactorable) 0.2.1 (tests only)
- [KeychainAccess](https://cocoapods.org/pods/KeychainAccess) 4.1.0
- [Restler](https://git.railwaymen.org/open/restler/) 0.4.2
- [Swifter](https://cocoapods.org/pods/Swifter) 1.4.7 (tests only)
- [SwiftLint](https://cocoapods.org/pods/SwiftLint) 0.39.1

### Bundler

- [Cocoapods](https://cocoapods.org) 1.9.1
- [Fastlane](https://fastlane.tools) 2.144.0
- [Slather](https://github.com/SlatherOrg/slather) 2.4.7
- [xcode-install](https://github.com/xcpretty/xcode-install) 2.6.3
- [xcov](https://github.com/nakiostudio/xcov) 1.7.2
