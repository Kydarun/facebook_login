library facebook_login_platform_interface;

part 'src/types.dart';

abstract class FacebookLoginPlatform {
  FacebookLoginPlatform();
  
  Future<FacebookLoginResult> login(List<String> permissions) async {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<FacebookAccessToken> getAccessToken() async {
    throw UnimplementedError('getAccessToken() has not been implemented.');
  }
  
  Future<void> logout() async {
    throw UnimplementedError('logOut() has not been implemented.');
  }

  
}