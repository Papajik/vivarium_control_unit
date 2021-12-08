# vivarium_control_unit

Vivarium Control App

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Hive:
1 - FeedType
2 - FeedTrigger
3 - LedTrigger
4 - HeaterType
5 - SocketTrigger

flutter packages pub run build_runner build --delete-conflicting-outputs

https://dribbble.com/shots/3316056-Fish-Tank-Aquarium-CSS-Animation
https://www.uplabs.com/posts/aquarium-with-fish-animation-pure-css


https://developers.google.com/web/fundamentals/primers/service-workers

https://firebase.google.com/docs/web/setup#available-libraries

## Generate Class Diagram

### All models
flutter pub global run dcdg -s ./lib/models/ -o diagram/nomnoml/allModels.txt -b nomnoml

### All Utils

flutter pub global run dcdg -s ./lib/utils/ -o diagram/nomnoml/allUtils.txt -b nomnoml




flutter pub global run dcdg --exclude View,view,Card,Tab,tab,Tabs,Drawer,Picker,tabs,State,Main,Page,Provider,StatefulWidget,Store,Route,routes,entrypoint,Widget,localization,Trad,LocalizationsDelegate,TextInputFormatter,SystemPadding,CustomClipper,ArcClipper,MyApp,DisplayPictureScreen,Service -o diagram/dart_class_diagram.puml

flutter pub global run dcdg --include VivariumApp -o diagram/custom.puml

flutter pub global run dcdg -s ./lib/models/device --include Device,Camera,DeviceInfo,DeviceSensorData,DeviceSettings,DeviceState -o diagram/custom1.puml


java -DPLANTUML_LIMIT_SIZE=65536 -jar plantuml.jar
