#!/bin/sh
 
echo "Retrieving credential files..."

gsutil cp gs://crowdleague-credentials/GoogleService-Info.plist ./ios/Runner/GoogleService-Info.plist
gsutil cp gs://crowdleague-credentials/gc_keys.json ./ios/gc_keys.json
gsutil cp gs://crowdleague-credentials/google-services.json ./android/app/google-services.json
gsutil cp gs://crowdleague-credentials/keystore.jks ./android/app/keystore.jks
gsutil cp gs://crowdleague-credentials/keystore.config ./android/app/keystore.config
gsutil cp gs://crowdleague-credentials/crowdleague-fastlane-manager.json ./android/crowdleague-fastlane-manager.json
gsutil cp gs://crowdleague-credentials/firebase-functions-admin-key.json ./functions/firebase-functions-admin-key.json
