package com.xzp.qrcode_flutter

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import java.lang.ref.WeakReference

object FlutterRegister {
    var activity: WeakReference<Activity>? = null
    var messenger: BinaryMessenger? = null
    var activityBinding: ActivityPluginBinding? = null
    var registrar: PluginRegistry.Registrar? = null
    fun getActivity(): Activity? {
        return activity?.get()
    }

    //获取权限
    fun addRequestPermissionsResultListener(listerner: PluginRegistry.RequestPermissionsResultListener) {
        if (activityBinding != null) {
            activityBinding?.addRequestPermissionsResultListener(listerner)
        } else {
            registrar?.addRequestPermissionsResultListener(listerner)
        }
    }

    fun clear() {
        activity?.clear()
        activity?.clear()
        messenger = null
        registrar = null
        activityBinding = null
    }
}