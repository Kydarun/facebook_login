#import "FacebookLoginPlugin.h"
#if __has_include(<facebook_login/facebook_login-Swift.h>)
#import <facebook_login/facebook_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "facebook_login-Swift.h"
#endif

@implementation FacebookLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookLoginPlugin registerWithRegistrar:registrar];
}
@end
