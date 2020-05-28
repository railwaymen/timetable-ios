fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios check_style
```
fastlane ios check_style
```
Check style
### ios test
```
fastlane ios test
```
Run tests
### ios build_ipa
```
fastlane ios build_ipa
```
Build release ipa.
### ios deploy_stage
```
fastlane ios deploy_stage
```
Submit to Crashlytics stage version.
### ios deploy_testflight
```
fastlane ios deploy_testflight
```
Submit to Test Flight production version.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
