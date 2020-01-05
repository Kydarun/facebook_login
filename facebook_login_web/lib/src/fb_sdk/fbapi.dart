@JS()
library fb;

import "package:js/js.dart";

typedef ResponseCallback(Response response);

@JS('FB.login')
external void login(ResponseCallback callback, Map<String, String> scope);

@JS('FB.logout')
external void logout(ResponseCallback callback);

@JS('FB.getLoginStatus')
external void getLoginStatus(ResponseCallback callback);

@anonymous
@JS()
abstract class Response {
  static const String connected = 'connected';
  static const String notAuthorized = 'not_authorized';
  static const String error = 'error';

  external String get status;
  external AuthResponse get authResponse;
}

@anonymous
@JS()
abstract class AuthResponse {
  external String get accessToken;
  external String get userID;
  external String get expiresIn;
  //signedRequest:'...',
}
