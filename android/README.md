# NoKey Android Version

## Develop

You'll need [Android Studio](https://developer.android.com/studio/index.html).

## Release

  * increment version in build.gradle
  * build -> generate signed apk
  * upload apk to play console: https://play.google.com/apps/publish
  * download derived apk
  * test on local device: `adb install -r 3-1.apk`
  * upload to github releases
