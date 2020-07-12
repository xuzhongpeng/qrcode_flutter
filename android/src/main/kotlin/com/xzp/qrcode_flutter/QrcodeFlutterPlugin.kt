package com.xzp.qrcode_flutter

import android.graphics.BitmapFactory
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.RGBLuminanceSource
import com.google.zxing.common.HybridBinarizer
import com.google.zxing.qrcode.QRCodeReader
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.ref.WeakReference
import java.util.*

class QrcodeFlutterPlugin : MethodChannel.MethodCallHandler, FlutterPlugin, ActivityAware {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call?.method) {
            "getQrCodeByImagePath" -> {
                val path = call.arguments as String
                // DecodeHintType 和EncodeHintType
                val options = BitmapFactory.Options()
                options.inJustDecodeBounds = true
                BitmapFactory.decodeFile(path, options)
                options.inJustDecodeBounds = false
                val fixWidth = 400
                var sampleSize = (options.outWidth / fixWidth + options.outHeight / fixWidth) / 2
                if (sampleSize < 0) {
                    sampleSize = 1
                }
                options.inSampleSize = sampleSize
                var bitmap = BitmapFactory.decodeFile(path, options)
                val width = bitmap.width
                val height = bitmap.height
                val pixels = IntArray(width * height)
                bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
                var source = RGBLuminanceSource(width, height, pixels)
                var hints: Hashtable<DecodeHintType, String> = Hashtable<DecodeHintType, String>()
                hints.put(DecodeHintType.CHARACTER_SET, "utf-8"); // 设置二维码内容的编码
                try {
                    var result1 = QRCodeReader().decode(BinaryBitmap(HybridBinarizer(source)), hints)
                    result.success(listOf(result1.text))
                } catch (e: Exception) {
                    // nothing qrcode found
                    val list: List<String> = listOf()
                    result.success(list)
                }
            }
        }
    }

    override fun onDetachedFromActivity() {
        FlutterRegister.clear()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivityForConfigChanges() {
//        activity=null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        FlutterRegister.clear()
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        FlutterRegister.messenger=binding.binaryMessenger
        register(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        FlutterRegister.activityBinding = binding
        FlutterRegister.activity= WeakReference(binding.activity)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            FlutterRegister.registrar = registrar
            FlutterRegister.messenger = registrar.messenger()
            FlutterRegister.activity = WeakReference(registrar.activity())
            registrar.platformViewRegistry().registerViewFactory("plugins/qr_capture_view", QRCaptureViewFactory())
            var channel = MethodChannel(registrar.messenger(), "plugins/qr_capture/method")
            channel.setMethodCallHandler(QrcodeFlutterPlugin())
        }
        //v2 embedding
        fun register(binding: FlutterPlugin.FlutterPluginBinding) {
            FlutterRegister.messenger=binding.binaryMessenger
            binding.platformViewRegistry.registerViewFactory("plugins/qr_capture_view", QRCaptureViewFactory())
            var channel = MethodChannel(binding.binaryMessenger, "plugins/qr_capture/method")
            channel.setMethodCallHandler(QrcodeFlutterPlugin())
        }
    }
}
