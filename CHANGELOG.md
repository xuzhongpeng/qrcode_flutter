## 3.1.0
1. upgrade kotlin to 1.7.21 since 1.3.40 is too old
2. upgrade zxing android to [latest 4.3.0](https://mvnrepository.com/artifact/com.journeyapps/zxing-android-embedded)
3. remove unused android plugin:kapt and kae since this will block kotlin upgrade of 1.8+
4. change android jcenter to mavenCentral since jcenter is [abandoned in 2021](https://developer.android.google.cn/studio/build/jcenter-migration)
5. upgrade agp from 3.2.1 to 3.6.4 since 3.2.1 is too old and 3.6.4 is [last stable release of agp 3+](https://developer.android.google.cn/studio/releases/gradle-plugin)
## 3.0.0-nullsafety.0
1. Support null safety
## 2.0.1
1. add documents
## 2.0.0

1. fix [#5 add dispose method](https://github.com/xuzhongpeng/qrcode_flutter/issues/5)
2. fix [10 相机不允许使用时，打开扫码功能会闪退](https://github.com/xuzhongpeng/qrcode_flutter/issues/10)
3. fix [issue8--Can't add a nil AVCaptureInput](https://github.com/xuzhongpeng/qrcode_flutter/issues/8)
4. fix [issue7--divide by zero](https://github.com/xuzhongpeng/qrcode_flutter/issues/7).Fixed only by upgrade [zixing4.0.2](https://github.com/journeyapps/zxing-android-embedded/issues/334)
## 1.0.9

1. dealloc camera view when camera page pop from flutter [pr6](https://github.com/xuzhongpeng/qrcode_flutter/pull/6)

## 1.0.8

1. Plugin can register many time
2. [Improvement: allow mocking of plugin method channel](https://github.com/xuzhongpeng/qrcode_flutter/pull/4)

## 1.0.6

1. fix small qrcode images scanning correct

## 1.0.5

1.fix requestPermissions callback error(cause open camera error when agree permissions)

## 1.0.4

1. change `implementation "com.journeyapps:zxing-android-embedded:3.5.0"` to `api "com.journeyapps:zxing-android-embedded:3.5.0"`(because the library `zxing-android-embedded` has built the class `CameraConfigurationUtils` the same as `com.google.zxing:android-core:3.2.1`)
2. fix Android clear bugs

## ~~1.0.3~~

1. fix iOS errors
2. Support Android V2 embedding.
3. Change the result of the scanned album to List

## ~~1.0.2~~

1. Support Android V2 embedding.
2. Change the result of the scanned album to List


## 1.0.1

Modify the document

## 1.0.0

提供相机扫码功能，提供照片解析功能（通过相册选择照片或者网络下载照片）

You can customize your page using by PlatformView.Scanning Picture from path(photo album).


