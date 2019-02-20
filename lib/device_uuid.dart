import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Uuid {
  final String uuid;

  Uuid(this.uuid);

  @override
  String toString() {
    return uuid;
  }
}

class DeviceUuid {
  // START Singleton: https://stackoverflow.com/questions/12649573/how-do-you-build-a-singleton-in-dart/12649574#12649574

  static final DeviceUuid _singleton = new DeviceUuid._internal();

  factory DeviceUuid() {
    return _singleton;
  }

  DeviceUuid._internal();

  // END Singleton

  static const MethodChannel _channel = const MethodChannel('device_uuid');

  Uuid _deviceUuid;

  Future<Uuid> get uuid async {
    final String uuid = await _channel.invokeMethod('getUuid');
    return Uuid(uuid);
  }

  Future<Uuid> get deviceUuid async {
    if (_deviceUuid != null) {
      return _deviceUuid;
    }

    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, "device_uuid.db");

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db
              .execute(
              "CREATE TABLE device_uuid (device_uuid TEXT PRIMARY KEY)");
        });

    List<Map<String, dynamic>> rawDeviceUuid =
    await database.rawQuery("SELECT device_uuid FROM device_uuid LIMIT 1;");

    if (rawDeviceUuid.length == 0) {
      // Generate a new UUID
      Uuid deviceUuid = await uuid;

      // Save it to DB
      int insertCount = await database.rawInsert(
          "INSERT INTO device_uuid(device_uuid) VALUES(?)", [deviceUuid.uuid]);
      assert(insertCount == 1);
      _deviceUuid = deviceUuid;
    } else {
      // Return the device_uuid in DB if it exists
      _deviceUuid = Uuid(rawDeviceUuid[0]["device_uuid"].toString());
    }

    return deviceUuid;
  }
}
