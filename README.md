![license MIT](https://img.shields.io/github/license/xuzhongpeng/qrcode_flutter)
[![qrCode_flutter](https://img.shields.io/pub/v/qrcode_flutter.svg)](https://pub.dev/packages/qrcode_flutter)
![iOS&Android](https://img.shields.io/badge/platform-Android%7CiOS%7CWeb-red)

# qrcode_flutter

## introduce

[pub.dev](https://pub.dev/packages/qrcode_flutter)

Flutter plugin for scanning QR codes.You can customize your page by using PlatformView.Scanning Picture from path(photo album).

You can download [flutter_demo.apk](https://blog-1253495453.cos.ap-chongqing.myqcloud.com/app-debug.apk) for testing

## Usage

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  QRCaptureController _controller = QRCaptureController();

  bool _isTorchOn = false;

  String _captureText = '';

  @override
  void initState() {
    super.initState();

    _controller.onCapture((data) {
      print('$data');
      setState(() {
        _captureText = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('scan'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              PickedFile image =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              var qrCodeResult =
                  await QRCaptureController.getQrCodeByImagePath(image.path);
              setState(() {
                _captureText = qrCodeResult.join('\n');
              });
            },
            child: Text('photoAlbum', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 300,
            child: QRCaptureView(
              controller: _controller,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar(),
            ),
          ),
          Container(
            child: Text('$_captureText'),
          )
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            _controller.pause();
          },
          child: Text('pause'),
        ),
        TextButton(
          onPressed: () {
            if (_isTorchOn) {
              _controller.torchMode = CaptureTorchMode.off;
            } else {
              _controller.torchMode = CaptureTorchMode.on;
            }
            _isTorchOn = !_isTorchOn;
          },
          child: Text('torch'),
        ),
        TextButton(
          onPressed: () {
            _controller.resume();
          },
          child: Text('resume'),
        ),
      ],
    );
  }
}
```

## Integration

### iOS

To use on iOS, you must add the following to your Info.plist

```
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for qrcode scanning.</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```
