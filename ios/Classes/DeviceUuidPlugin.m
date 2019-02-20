#import "DeviceUuidPlugin.h"
#import <device_uuid/device_uuid-Swift.h>

@implementation DeviceUuidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceUuidPlugin registerWithRegistrar:registrar];
}
@end
