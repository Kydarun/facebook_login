import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:facebook_login_platform_interface/facebook_login_platform_interface.dart';
import "package:js/js_util.dart" show promiseToFuture;
import 'src/load_fbapi.dart' as loadFbApi;
import 'src/fb_sdk/fbapi.dart' as fbApi;

class FacebookLoginWeb extends FacebookLoginPlatform {
  static const MethodChannel _channel =
      const MethodChannel('com.kydarun/facebook_login');

  Future<void> _isFbapiInitialized;

  FacebookLoginWeb() {
    _isFbapiInitialized = loadFbApi.init();
  }

  @visibleForTesting
  Future<void> get initialized => _isFbapiInitialized;

  Future<FacebookLoginResult> login(List<String> permissions) async {
    await initialized;
    fbApi.login((fbApi.Response response) {
      print(response);
    }, {'scope': permissions.join(',')});
    return null;
  }

  Future<FacebookAccessToken> getAccessToken() async {
    await initialized;
    fbApi.getLoginStatus((fbApi.Response response) {
      print(response);
    });
    return null;
  }
  
  Future<void> logout() async {
    await initialized;
    fbApi.logout((fbApi.Response response) {
      print(response);
    });
    return null;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
