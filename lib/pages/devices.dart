import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<RokuDevice> devices = [];

  @override
  void initState() {
    super.initState();
    getListOfDevices();
  }

  Future<void> getListOfDevices() async {
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP(); // 192.168.1.43

    final String ip = wifiIP as String;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    for (int i = 0; i < 999; i++) {
      IsIpRoku(subnet + "." + i.toString() + ":8060");
    }
    var wifiName = await info.getWifiName(); // FooNetwork
    print(wifiName);
  }

  Future<bool> IsIpRoku(String ip) async {
    var url = Uri.parse("http://" + ip);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.contains('roku')) {
          print(ip + " is roku");
          String deviceName = '';
          const String startingName = '<friendlyName>55&quot;';
          deviceName = response.body
              .substring(
                  response.body.indexOf(startingName) + startingName.length,
                  response.body.indexOf('</friendlyName>'))
              .trim();
          print(deviceName);
          devices.add(RokuDevice(ip, deviceName));
          return true;
        }
      }
    } catch (e) {
      //print(e.toString());
    }

    return false;
  }

  Future<void> buttonPressed(String key) async {
    var url = Uri.parse('http://192.168.1.95:8060/keypress/' + key);
    var response = await http.post(url);
    if (kDebugMode) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Roku Devices'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () => {getListOfDevices()},
                  child: const Icon(Icons.refresh)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () => {getListOfDevices()},
        ),
      );
}

class RokuDevice {
  String name = '';
  String ip = '';

  RokuDevice(this.ip, this.name);
}
