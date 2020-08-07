#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@",url.absoluteString);
    if([url.scheme isEqualToString:@"FlutterKbzPay"]) {
        NSString *resultCode = [self getParamByName:@"EXTRA_RESULT" URLString:url.absoluteString];
        NSString *merchant_order_id = [self getParamByName:@"EXTRA_ORDER_ID" URLString:url.absoluteString];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:resultCode forKey:@"EXTRA_RESULT"];
        [params setValue:merchant_order_id forKey:@"EXTRA_ORDER_ID"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPCallBack" object:params];
    }
    return YES;
}

- (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url
{
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return @"";
}

@end
