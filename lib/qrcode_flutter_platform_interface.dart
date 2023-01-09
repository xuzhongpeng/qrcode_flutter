import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qrcode_flutter_io.dart';

/// get qrcode data in callback
/// 定义回调函数，返回扫码数据
typedef CaptureCallback = Function(String data);

/// PhoneTorch
/// 闪光灯开关
enum CaptureTorchMode {
  /// ON
  on,

  /// OFF
  off
}
/// 定义插件抽象
abstract class QrcodeFlutterPlatform extends PlatformInterface {
  /// Constructs a QrcodeFlutterPlatform.
  QrcodeFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static QrcodeFlutterPlatform _instance = QRCodeFlutterIO();

  /// The default instance of [QrcodeFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelQrcodeFlutter].
  static QrcodeFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QrcodeFlutterPlatform] when
  /// they register themselves.
  static set instance(QrcodeFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 暂停扫码
  /// resume scanning code from camera
  void pause();

  /// 当调用[pause]后，恢复扫码
  /// resume scanning code from camera after [pause]
  void resume() ;

  /// 停止扫码
  /// Stop scanning code from camera
  void dispose();

  /// 获取数据的回调函数
  /// The callback function that gets the data from camera
  void onCapture(CaptureCallback capture) ;

  /// 控制相机开关回调函数
  /// PhoneTorch ON or OFF
  set torchMode(CaptureTorchMode mode) ;

  /// 从相机获取二维码并返回扫码信息
  /// Get the qrcode data from photo album
  Future<List<String>> getQrCodeByImagePath(String path);

  /// Build camera widget
  Widget buildWidget();
}
