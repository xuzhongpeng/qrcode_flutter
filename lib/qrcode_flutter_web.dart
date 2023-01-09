// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'qrcode_flutter_platform_interface.dart';

const String _tag = '[qrcode_flutter_web]';

/// A web implementation of the QrcodeFlutterPlatform of the QrcodeFlutter plugin.
class QrcodeFlutterWeb extends QrcodeFlutterPlatform {
  final String _viewType = 'flutter_plugin_camera';
  CaptureCallback? _capture;

  /// Constructs a QrcodeFlutterWeb
  QrcodeFlutterWeb() {
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        _viewType,
        (int viewId) => html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..id = _viewType);
    html.document.body!.append(html.ScriptElement()
      ..src =
          'assets/packages/qrcode_flutter/assets/html5-qrcode.min.js' // ignore: unsafe_html
      ..type = 'application/javascript');
    html.document.body!.append(html.ScriptElement()
      ..src =
          'assets/packages/qrcode_flutter/assets/qrcode_flutter_web.js' // ignore: unsafe_html
      ..type = 'application/javascript');
    js_util.setProperty(html.window, "onCapture", js.allowInterop((args) {
      _capture?.call(args);
    }));
  }

  // ignore: public_member_api_docs
  static void registerWith(Registrar registrar) {
    QrcodeFlutterPlatform.instance = QrcodeFlutterWeb();
  }

  @override
  void dispose() {
    js.context.callMethod('dispose');
    _capture = null;
  }

  @override
  Future<List<String>> getQrCodeByImagePath(String path) {
    throw UnimplementedError('$_tag not support getQrCodeByImagePath on Web');
  }

  @override
  void onCapture(CaptureCallback capture) {
    _capture = capture;
  }

  @override
  void pause() {
    js.context.callMethod('pause');
  }

  @override
  void resume() {
    js.context.callMethod('resume');
  }

  @override
  set torchMode(CaptureTorchMode mode) {
    if (kDebugMode) {
      print('$_tag not support torchMode on Web');
    }
  }

  @override
  Widget buildWidget() => _QRcodeFlutter(
        viewType: _viewType,
        controller: this,
      );
}

class _QRcodeFlutter extends StatefulWidget {
  final String viewType;
  final QrcodeFlutterWeb controller;
  const _QRcodeFlutter(
      {Key? key, required this.viewType, required this.controller})
      : super(key: key);

  @override
  State<_QRcodeFlutter> createState() => __QRcodeFlutterState();
}

class __QRcodeFlutterState extends State<_QRcodeFlutter> {
  @override
  void initState() {
    super.initState();
  }

  double? _width;
  double? _height;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  _init(double width, double height) {
    if (_width != width || _height != height) {
      if (_width != null && _height != null) {
        // not first call
        try {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            js.context.callMethod('rebuild', [width, height]);
          });
        } catch (e) {
          if (kDebugMode) {
            print('$_tag rebuild error: $e');
          }
        }
      } else {
        try {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            js.context.callMethod('firstBuild', [width, height]);
          });
        } catch (e) {
          if (kDebugMode) {
            print('$_tag firstBuild error: $e');
          }
        }
      }
      _width = width;
      _height = height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _init(constraints.maxWidth, constraints.maxHeight);
      return HtmlElementView(viewType: widget.viewType);
    });
  }
}
