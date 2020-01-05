package com.kydarun.facebook.login.facebook_login

import androidx.annotation.NonNull
import com.facebook.AccessToken
import com.facebook.CallbackManager
import com.facebook.login.LoginManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FacebookLoginPlugin */
class FacebookLoginPlugin(private val registrar: Registrar) : FlutterPlugin, MethodCallHandler {
  private val loginManager: LoginManager = LoginManager.getInstance()
  private val callback: CallbackManager = CallbackManager.Factory.create()
  private val resultDelegate: FacebookLoginResultDelegate = FacebookLoginResultDelegate(callback)

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.kydarun/facebook_login")
    channel.setMethodCallHandler(FacebookLoginPlugin(registrar))
    loginManager.registerCallback(callback, resultDelegate)
    registrar.addActivityResultListener(resultDelegate)
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "com.kydarun/facebook_login")
      channel.setMethodCallHandler(FacebookLoginPlugin(registrar))
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "login" -> {
          resultDelegate.setPendingResult("login", result)
          val permissions: List<String> = call.argument<List<String>>("permissions") ?: listOf()
          loginManager.logIn(registrar.activity(), permissions)
        }
        "logout" -> {
          loginManager.logOut();
          result.success(null)
        }
        "getAccessToken" -> {
          val accessToken: AccessToken = AccessToken.getCurrentAccessToken()
          result.success(mapOf<String, Any>(
                  "token" to accessToken.token,
                  "userId" to accessToken.userId,
                  "expires" to accessToken.expires,
                  "permissions" to accessToken.permissions,
                  "declinedPermissions" to accessToken.declinedPermissions
          ))
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

  }
}
