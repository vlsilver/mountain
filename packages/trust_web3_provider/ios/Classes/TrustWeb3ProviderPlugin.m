#import "TrustWeb3ProviderPlugin.h"
#if __has_include(<trust_web3_provider/trust_web3_provider-Swift.h>)
#import <trust_web3_provider/trust_web3_provider-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "trust_web3_provider-Swift.h"
#endif

@implementation TrustWeb3ProviderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTrustWeb3ProviderPlugin registerWithRegistrar:registrar];
}
@end
