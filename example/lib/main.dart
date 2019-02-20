import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_uuid/device_uuid.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uuid _deviceUuid;

  @override
  void initState() {
    super.initState();
    initDeviceUuidState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDeviceUuidState() async {
    Uuid deviceUuid;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceUuid = await DeviceUuid().deviceUuid;
    } on PlatformException {
      print('Failed to get device uuid.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceUuid = deviceUuid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device UUID example app'),
        ),
        body: Center(
          child: _deviceUuid == null
              ? Text('Loading Device UUID')
              : Text('Device UUID:\n${_deviceUuid.uuid}\n'),
        ),
      ),
    );
  }
}
