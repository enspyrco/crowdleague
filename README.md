# crowdleague

CrowdLeague is a platform for crowd sourcing sports leagues. Be in a league of your own...

[github](https://github.com/nickmeinhold/crowdleague_public) | [firebase console](https://console.firebase.google.com/u/0/project/crowdleague1/overview)

[Google Play Console](https://play.google.com/apps/publish/?account=6095168526928626772#AppDashboardPlace:p=tmp.06172670794154685202.1586081744174.6623537&appid=4973683335528364155) | [App Store Connect](https://appstoreconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1506440961)

## Common Commands 

```sh
flutter pub run build_runner build
```

## Get Credential Files

```sh
chmod 755 ./get-credentials.sh
./get-credentials.sh
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