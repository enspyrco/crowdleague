# crowdleague

CrowdLeague is a platform for crowd sourcing sports leagues. Be in a league of your own...

[github](https://github.com/nickmeinhold/crowdleague_public) | [firebase console](https://console.firebase.google.com/u/0/project/crowdleague1/overview)

[Google Play Console](https://play.google.com/apps/publish/?account=6095168526928626772#AppDashboardPlace:p=tmp.06172670794154685202.1586081744174.6623537&appid=4973683335528364155) | [App Store Connect](https://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1506440961)

## Common Commands 

```sh
flutter pub run build_runner build
```

## Get Credential Files

If you are a contributor with access to our Firebase project you can just run: 
```sh
./get-credentials.sh
```

Otherwise you will need to create your own Firebase project and add config files:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

as specified in:

- [Add Firebase to your Android project](https://firebase.google.com/docs/android/setup) 
- [Add Firebase to your iOS project](https://firebase.google.com/docs/ios/setup)

### iOS Signing with Match

We use [match](https://docs.fastlane.tools/actions/match/) to manage Provisioning Profiles and Certificates. Match uses `gc_keys.json` to authenticate, which was downloaded in the previous step.

To install the required Provisioning Profiles and Certificates:

```sh
cd ios; fastlane match development
```

## Cloud Functions

We use Cloud Functions for Firebase to automatically run backend code in response to events triggered by Firebase features, such as:

- Initial Sign In
- Changes to Firestore that should send an FCM

The relevant code is all in `functions/`

After making changes to `functions/src/index.ts`

```sh
firebase deploy --only functions
```

## Screenshots 

To setup, follow the instructions in [screenshots | Dart Package](https://pub.dev/packages/screenshots) 

The configuration file is `screenshots.yaml`

You will need appropriately named emulators and the emulators may (shouldn't but may) need to be open.

From the project dir, run: 

```sh
screeenshots
```

## Redux RemoteDevTools (RDT)

- find the IP address of the computer 
- use one of the strings in `utilities/mock.dart` or make a new one 
- edit `main.dart` to use the correct IP 
- run the remotedev server

```
remotedev --port 8000
```

- open a web page with url:

```
http://localhost:8000
```

## Code gen with built_value 

After making changes to built_value classes run the builder to generate the new code:

```sh
flutter pub run build_runner build
```

## App Icons 

We use [flutter_launcher_icons](https://github.com/fluttercommunity/flutter_launcher_icons). To change the app icons, replace `assets/images/app-icon-large-white.png` and run: 

```sh
flutter pub run flutter_launcher_icons:main
```

## Tests 

### Unit and Widget Tests 

```sh
flutter test
```