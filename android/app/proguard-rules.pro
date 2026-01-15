# Flutter Stripe - ignore missing push provisioning classes
# These are React Native classes that aren't used in Flutter
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.**

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.maps.** { *; }
-dontwarn com.google.android.gms.**
