#!/bin/sh
 
echo "Retrieving dependencies and running code gen..."

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
