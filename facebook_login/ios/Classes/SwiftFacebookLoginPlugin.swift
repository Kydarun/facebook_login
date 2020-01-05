import Flutter
import UIKit
import FBSDKLoginKit

public class SwiftFacebookLoginPlugin: NSObject, FlutterPlugin {
  private var loginManager: LoginManager = LoginManager()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.kydarun/facebook_login", binaryMessenger: registrar.messenger())
    let instance = SwiftFacebookLoginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
      case "getPlatformVersion":
        result("iOS: " + UIDevice.current.systemVersion)
        break
      case "login":
        let permissions = (call.arguments as? NSDictionary)?["permissions"] as? [String] ?? []
        self.loginManager.logIn(permissions: permissions, from: nil, handler: {
            loginResult, error in
            if (loginResult?.isCancelled ?? false) {
                let accessToken = loginResult?.token
                result([
                    "status": "cancelledByUser"
                ] as NSDictionary)
            }
            if (loginResult?.token != nil) {
                let accessToken = loginResult?.token
                result([
                    "status": "loggedIn",
                    "accessToken": [
                        "token": accessToken?.tokenString ?? "",
                        "userId": accessToken?.userID ?? "",
                        "expires": accessToken?.expirationDate ?? "",
                        "permissions": loginResult?.grantedPermissions ?? "",
                        "declinedPermissions": loginResult?.declinedPermissions ?? ""
                    ] as NSDictionary
                ] as NSDictionary)
            }
            result([
                "status": "error",
                "errorMessage": error?.localizedDescription ?? "An unknown error occurred."
            ] as NSDictionary)
        } as LoginManagerLoginResultBlock)
        break
      case "logout":
        self.loginManager.logOut()
        result(nil)
        break
      case "getAccessToken":
        let accessToken = AccessToken.current
        result([
            "token": accessToken?.tokenString ?? "",
            "userId": accessToken?.userID ?? "",
            "expires": accessToken?.expirationDate ?? ""
        ] as NSDictionary)
        break
      default:
        result(FlutterMethodNotImplemented)
    }
    
    result("iOS " + UIDevice.current.systemVersion)
  }
}
