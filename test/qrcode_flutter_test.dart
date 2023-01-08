import 'package:flutter_test/flutter_test.dart';
import 'package:qrcode_flutter/qrcode_flutter.dart';
import 'package:qrcode_flutter/qrcode_flutter_platform_interface.dart';
import 'package:qrcode_flutter/qrcode_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQrcodeFlutterPlatform
    with MockPlatformInterfaceMixin
    implements QrcodeFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final QrcodeFlutterPlatform initialPlatform = QrcodeFlutterPlatform.instance;

  test('$MethodChannelQrcodeFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQrcodeFlutter>());
  });

  test('getPlatformVersion', () async {
    QrcodeFlutter qrcodeFlutterPlugin = QrcodeFlutter();
    MockQrcodeFlutterPlatform fakePlatform = MockQrcodeFlutterPlatform();
    QrcodeFlutterPlatform.instance = fakePlatform;

    expect(await qrcodeFlutterPlugin.getPlatformVersion(), '42');
  });
}
