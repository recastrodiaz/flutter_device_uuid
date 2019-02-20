package red.rodrigo.deviceuuid;

import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** DeviceUuidPlugin */
public class DeviceUuidPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "device_uuid");
    channel.setMethodCallHandler(new DeviceUuidPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String uuid = UUID.randomUUID().toString();
    result.success(uuid);
  }
}
