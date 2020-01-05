class FacebookLoginResult {
  final FacebookLoginStatus status;
  final FacebookAccessToken accessToken;
  final String errorMessage;

  FacebookLoginResult({this.status, this.accessToken, this.errorMessage});

  FacebookLoginResult.fromMap(Map<String, dynamic> map)
      : status = _parseStatus(map['status']),
        accessToken = map['accessToken'] != null
            ? FacebookAccessToken.fromMap(
                map['accessToken'].cast<String, dynamic>(),
              )
            : null,
        errorMessage = map['errorMessage'];

  static FacebookLoginStatus _parseStatus(String status) {
    switch (status) {
      case 'loggedIn':
        return FacebookLoginStatus.loggedIn;
      case 'cancelledByUser':
        return FacebookLoginStatus.cancelledByUser;
      case 'error':
        return FacebookLoginStatus.error;
    }

    throw StateError('Invalid status: $status');
  }
}

enum FacebookLoginStatus {
  loggedIn,
  cancelledByUser,
  error,
}

class FacebookAccessToken {
  final String token;
  final String userId;
  final DateTime expires;
  final List<String> permissions;
  final List<String> declinedPermissions;

  FacebookAccessToken({this.token, this.userId, this.expires, 
    this.permissions, this.declinedPermissions});

  bool get valid => DateTime.now().isBefore(expires ?? DateTime.now());

  FacebookAccessToken.fromMap(Map<String, dynamic> map)
      : token = map['token'],
        userId = map['userId'],
        expires = DateTime.fromMillisecondsSinceEpoch(
          map['expires'],
          isUtc: true,
        ),
        permissions = map['permissions'].cast<String>(),
        declinedPermissions = map['declinedPermissions'].cast<String>();
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'userId': userId,
      'expires': expires.millisecondsSinceEpoch,
      'permissions': permissions,
      'declinedPermissions': declinedPermissions,
    };
  }
}