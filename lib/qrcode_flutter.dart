import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef CaptureCallback(String data);

enum CaptureTorchMode { on, off }

class QRCaptureController {
  MethodChannel _methodChannel;
  CaptureCallback _capture;

  QRCaptureController();

  @visibleForTesting
  void onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('plugins/qr_capture/method_$id');
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        if (_capture != null && call.arguments != null) {
          _capture(call.arguments.toString());
        }
      }
    });
  }

  void pause() {
    _methodChannel?.invokeMethod('pause');
  }

  void resume() {
    _methodChannel?.invokeMethod('resume');
  }

  void dispose() {
    _methodChannel?.invokeMethod('resume');
  }
  
  void onCapture(CaptureCallback capture) {
    _capture = capture;
  }

  set torchMode(CaptureTorchMode mode) {
    var isOn = mode == CaptureTorchMode.on;
    _methodChannel?.invokeMethod('setTorchMode', isOn);
  }

  static Future<List<String>> getQrCodeByImagePath(String path) async {
    var _methodChannel = MethodChannel('plugins/qr_capture/method');
    var qrResult =
        await _methodChannel?.invokeMethod("getQrCodeByImagePath", path);
    return List<String>.from(qrResult);
  }
}

class QRCaptureView extends StatefulWidget {
  final QRCaptureController controller;
  QRCaptureView({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QRCaptureViewState();
  }
}

class QRCaptureViewState extends State<QRCaptureView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller.onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller.onPlatformViewCreated(id);
        },
      );
    }
  }
}
