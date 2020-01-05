import 'dart:async';

import 'package:flutter/services.dart';
import 'package:facebook_login_platform_interface/facebook_login_platform_interface.dart';

class FacebookLogin extends FacebookLoginPlatform {
  static const MethodChannel _channel =
      const MethodChannel('com.kydarun/facebook_login');

  FacebookLogin();

  Future<FacebookLoginResult> login(List<String> permissions) async {
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('logIn', {
      'permissions': permissions,
    });
    return FacebookLoginResult.fromMap(result);
  }

  Future<FacebookAccessToken> getAccessToken() async {
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('getAccessToken');
    return FacebookAccessToken.fromMap(result);
  }
  
  Future<void> logout() async {
    final result = await _channel.invokeMethod('logout');
    return result;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
