package com.example.flutter_plugin_demo

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import dev.flutter.pigeon.Pigeon
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import kotlin.math.round


class MainActivity: FlutterActivity() {
  // Extend the Pigeon-generated abstract class with an implementation.
  class BatteryPlugin(val Fn: () -> Long): Pigeon.BatteryApi {
    override fun getCurrentBatteryLevel(): Long {
      return Fn();
    }
  }

  private fun _getCurrentMediaVolumeLevel(): Long {
    val volumeLevel: Long

    val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
    volumeLevel = round(am.getStreamVolume(AudioManager.STREAM_MUSIC).toDouble()/am.getStreamMaxVolume(AudioManager.STREAM_MUSIC)*100).toLong()

    return volumeLevel
  }

  // Local function to interact with native platform. Directly copied from:
  // https://docs.flutter.dev/development/platform-integration/platform-channels?tab=android-channel-java-tab#step-3-add-an-android-platform-specific-implementation
  private fun _getCurrentBatteryLevel(): Long {
    val batteryLevel: Long
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getLongProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getLongExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }
    return batteryLevel
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    val binaryMessenger : BinaryMessenger? = flutterEngine?.dartExecutor?.binaryMessenger

    // Initialize plugins in activity onCreate.
    Pigeon.BatteryApi.setup(binaryMessenger, BatteryPlugin(::_getCurrentMediaVolumeLevel))
  }
}
