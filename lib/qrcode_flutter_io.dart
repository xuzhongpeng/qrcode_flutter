import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode_flutter/qrcode_flutter_platform_interface.dart';

/// support android and ios
class QRCodeFlutterIO extends QrcodeFlutterPlatform {
  MethodChannel? _methodChannel;
  CaptureCallback? _capture;

  /// 初始化方法，必须初始化
  /// The initialization method must be initialized
  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('plugins/qr_capture/method_$id');
    _methodChannel?.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        if (_capture != null && call.arguments != null) {
          _capture?.call(call.arguments.toString());
        }
      }
    });
  }

  /// 暂停扫码
  /// resume scanning code from camera
  @override
  void pause() {
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('pause');
  }

  /// 当调用[pause]后，恢复扫码
  /// resume scanning code from camera after [pause]
  @override
  void resume() {
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('resume');
  }

  /// 停止扫码
  /// Stop scanning code from camera
  @override
  void dispose() {
    pause();
    _capture = null;
    _methodChannel = null;
  }

  /// 获取数据的回调函数
  /// The callback function that gets the data from camera
  @override
  void onCapture(CaptureCallback capture) {
    _capture = capture;
  }

  /// 控制相机开关回调函数
  /// PhoneTorch ON or OFF
  @override
  set torchMode(CaptureTorchMode mode) {
    var isOn = mode == CaptureTorchMode.on;
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('setTorchMode', isOn);
  }

  /// 从相机获取二维码并返回扫码信息
  /// Get the qrcode data from photo album
  @override
  Future<List<String>> getQrCodeByImagePath(String path) async {
    var methodChannel = const MethodChannel('plugins/qr_capture/method');
    var qrResult =
        await methodChannel.invokeMethod("getQrCodeByImagePath", path);
    return List<String>.from(qrResult);
  }

  @override
  Widget buildWidget() {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    }
  }
}
