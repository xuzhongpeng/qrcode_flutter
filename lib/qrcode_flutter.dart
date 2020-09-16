import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void CaptureCallback(String data);

enum CaptureTorchMode { on, off }

class QRCaptureController {
  MethodChannel _methodChannel;

  CaptureCallback _capture;

  Duration _durationBetweenCaptures;

  bool _canCallCaptureCallback = true;

  QRCaptureController();

  void _onPlatformViewCreated(int id) {
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

  void onCapture(CaptureCallback capture) {
    _capture = (data) {
      if (_canCallCaptureCallback) {
        if (_durationBetweenCaptures != null) {
          _canCallCaptureCallback = false;

          Future.delayed(
            _durationBetweenCaptures,
            () {
              _canCallCaptureCallback = true;
            },
          );
        }

        capture(data);
      }
    };
  }

  set torchMode(CaptureTorchMode mode) {
    var isOn = mode == CaptureTorchMode.on;
    _methodChannel?.invokeMethod('setTorchMode', isOn);
  }

  void _setDurationBetweenCaptures(Duration duration) {
    _durationBetweenCaptures = duration;
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

  final Duration durationBetweenCaptures;

  QRCaptureView({
    Key key,
    @required this.controller,
    this.durationBetweenCaptures,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QRCaptureViewState();
  }
}

class QRCaptureViewState extends State<QRCaptureView> {
  @override
  void initState() {
    super.initState();

    if (widget.durationBetweenCaptures != null) {
      widget.controller._setDurationBetweenCaptures(
        widget.durationBetweenCaptures,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller._onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller._onPlatformViewCreated(id);
        },
      );
    }
  }
}
