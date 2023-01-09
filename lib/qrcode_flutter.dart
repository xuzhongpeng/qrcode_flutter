import 'package:flutter/widgets.dart';
import 'package:qrcode_flutter/qrcode_flutter_platform_interface.dart';
export 'package:qrcode_flutter/qrcode_flutter_platform_interface.dart';

/// 扫码及获取相册的控制类
///Scan code and access to the album control class
class QRCaptureController {
  final QrcodeFlutterPlatform _platform = QrcodeFlutterPlatform.instance;

  /// 构造函数
  QRCaptureController();

  /// 暂停扫码
  /// resume scanning code from camera
  void pause() {
    _platform.pause();
  }

  /// 当调用[pause]后，恢复扫码
  /// resume scanning code from camera after [pause]
  void resume() {
    _platform.resume();
  }

  /// 停止扫码
  /// Stop scanning code from camera
  void dispose() {
    _platform.dispose();
  }

  /// 获取数据的回调函数
  /// The callback function that gets the data from camera
  void onCapture(CaptureCallback capture) {
    _platform.onCapture(capture);
  }

  /// 控制相机开关回调函数
  /// PhoneTorch ON or OFF
  set torchMode(CaptureTorchMode mode) => _platform.torchMode = mode;

  /// 从相机获取二维码并返回扫码信息
  /// Get the qrcode data from photo album
  static Future<List<String>> getQrCodeByImagePath(String path) async {
    return QrcodeFlutterPlatform.instance.getQrCodeByImagePath(path);
  }

  Widget _buildWidget() {
    return _platform.buildWidget();
  }
}

/// 使用Platform View展示相机，可在Flutter View中自定义相机显示位置
/// Camera view
class QRCaptureView extends StatelessWidget {
  /// 控制器
  final QRCaptureController controller;

  /// key for Widget
  /// controller 相机控制器
  const QRCaptureView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller._buildWidget();
  }
}
