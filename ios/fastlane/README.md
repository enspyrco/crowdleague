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
### ios build_signed
```
fastlane ios build_signed
```
Build a signed app
### ios deploy_internal
```
fastlane ios deploy_internal
```
Deploy latest build to TestFlight
### ios build_signed_and_deploy_internal
```
fastlane ios build_signed_and_deploy_internal
```
Build signed app and deploy to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
