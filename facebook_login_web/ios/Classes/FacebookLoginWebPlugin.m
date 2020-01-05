#import "FacebookLoginWebPlugin.h"
#if __has_include(<facebook_login_web/facebook_login_web-Swift.h>)
#import <facebook_login_web/facebook_login_web-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "facebook_login_web-Swift.h"
#endif

@implementation FacebookLoginWebPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFacebookLoginWebPlugin registerWithRegistrar:registrar];
}
@end
