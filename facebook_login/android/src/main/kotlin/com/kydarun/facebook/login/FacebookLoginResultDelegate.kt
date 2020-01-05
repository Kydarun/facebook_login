package com.kydarun.facebook.login

import android.content.Intent
import com.facebook.AccessToken
import com.facebook.CallbackManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginResult
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class FacebookLoginResultDelegate(private val callbackManager: CallbackManager)
    : FacebookCallback<LoginResult>, PluginRegistry.ActivityResultListener {

    private var pendingResult: MethodChannel.Result? = null

    fun setPendingResult(methodName: String, result: MethodChannel.Result) {
        this.pendingResult?.error("login_in_progress",
                methodName + " called while another Facebook " +
                        "login operation was in progress.",
                null)
        this.pendingResult = result
    }

    override fun onSuccess(result: LoginResult?) {
        val accessToken: AccessToken = result!!.accessToken
        this.pendingResult?.success(mapOf(
                "status" to "loggedIn",
                "accessToken" to mapOf<String, Any>(
                        "token" to accessToken.token,
                        "userId" to accessToken.userId,
                        "expires" to accessToken.expires,
                        "permissions" to accessToken.permissions,
                        "declinedPermissions" to accessToken.declinedPermissions
                )
        ))
        this.pendingResult = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return callbackManager.onActivityResult(requestCode, resultCode, data)
    }

    override fun onCancel() {
        this.pendingResult?.success(mapOf(
                "status" to "cancelledByUser"
                )
        )
        this.pendingResult = null
    }

    override fun onError(error: FacebookException?) {
        this.pendingResult?.success(mapOf(
                "status" to "error",
                "errorMessage" to (error?.message ?: "An unknown error occurred.")
            )
        )
        this.pendingResult = null
    }
}