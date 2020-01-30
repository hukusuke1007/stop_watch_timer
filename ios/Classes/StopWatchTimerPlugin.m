#import "StopWatchTimerPlugin.h"
#if __has_include(<stop_watch_timer/stop_watch_timer-Swift.h>)
#import <stop_watch_timer/stop_watch_timer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "stop_watch_timer-Swift.h"
#endif

@implementation StopWatchTimerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftStopWatchTimerPlugin registerWithRegistrar:registrar];
}
@end
