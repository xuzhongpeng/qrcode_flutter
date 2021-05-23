import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// get qrcode data in callback
/// 定义回调函数，返回扫码数据
typedef CaptureCallback(String data);

/// PhoneTorch
/// 闪光灯开关
enum CaptureTorchMode {
  /// ON
  on,

  /// OFF
  off
}

/// 扫码及获取相册的控制类
///Scan code and access to the album control class
class QRCaptureController {
  MethodChannel? _methodChannel;
  CaptureCallback? _capture;

  /// 构造函数
  QRCaptureController();

  /// 初始化方法，必须初始化
  /// The initialization method must be initialized
  @visibleForTesting
  void onPlatformViewCreated(int id) {
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
  void pause() {
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('pause');
  }

  /// 停止扫码
  /// Stop scanning code from camera
  void resume() {
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('resume');
  }

  /// 停止扫码
  /// Stop scanning code from camera
  void dispose() {
    resume();
  }

  /// 获取数据的回调函数
  /// The callback function that gets the data from camera
  void onCapture(CaptureCallback capture) {
    _capture = capture;
  }

  /// 控制相机开关回调函数
  /// PhoneTorch ON or OFF
  set torchMode(CaptureTorchMode mode) {
    var isOn = mode == CaptureTorchMode.on;
    assert(_methodChannel != null,
        "_methodChannel can not be null. Please call onPlatformViewCreated first");
    _methodChannel?.invokeMethod('setTorchMode', isOn);
  }

  /// 从相机获取二维码并返回扫码信息
  /// Get the qrcode data from photo album
  static Future<List<String>> getQrCodeByImagePath(String path) async {
    var methodChannel = MethodChannel('plugins/qr_capture/method');
    var qrResult =
        await methodChannel.invokeMethod("getQrCodeByImagePath", path);
    return List<String>.from(qrResult);
  }
}

/// 使用Platform View展示相机，可在Flutter View中自定义相机显示位置
/// camera view
class QRCaptureView extends StatefulWidget {
  /// 控制器
  final QRCaptureController? controller;

  /// key for Widget
  /// controller 相机控制器
  QRCaptureView({Key? key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QRCaptureViewState();
  }
}

class _QRCaptureViewState extends State<QRCaptureView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller?.onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller?.onPlatformViewCreated(id);
        },
      );
    }
  }
}
