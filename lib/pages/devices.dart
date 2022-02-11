import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:unofficial_roku_remote/pages/remote.dart';
import '../widget/navifation_drawer_widget.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<RokuDevice> devices = [];
  bool gettingDevices = false;
  final LocalStorage storage = LocalStorage('roku');

  @override
  void initState() {
    super.initState();
    getListOfDevices();
  }

  Future<void> getListOfDevices() async {
    if (gettingDevices) {
      return;
    }

    gettingDevices = true;
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP(); // 192.168.1.43

    final String ip = wifiIP as String;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    List<Future> futures = [];
    for (int i = 0; i < 999; i++) {
      var future = isIpRoku(subnet + "." + i.toString());
      futures.add(future);
    }
    await Future.wait(futures);
    gettingDevices = false;
    // var wifiName = await info.getWifiName(); // FooNetwork
    // print(wifiName);
  }

  Future<bool> isIpRoku(String ip) async {
    var url = Uri.parse("http://" + ip + ":8060");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.contains('roku')) {
          print(ip + " is roku");
          String deviceName = '';
          const String startingName = '<friendlyName>';
          deviceName = response.body
              .substring(
                  response.body.indexOf(startingName) + startingName.length,
                  response.body.indexOf('</friendlyName>'))
              .trim();
          deviceName = deviceName.replaceAll('&quot;', '"');
          print(deviceName);
          devices.add(RokuDevice(ip, deviceName));
          setState(() {});
          return true;
        }
      }
    } catch (e) {
      //print(e.toString());
    }

    return false;
  }

  void deviceClicked(RokuDevice device) {
    storage.setItem("selectedDeviceIp", device.ip);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RemotePage()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(title: const Text('Roku Devices'), centerTitle: true),
        body: Align(
            alignment: Alignment.topCenter,
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Scrollbar(
                    isAlwaysShown: true,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView(
                          shrinkWrap: true,
                          children: devices
                              .map((e) => Center(
                                      child: ListTile(
                                    title: Text(e.name),
                                    subtitle: Text(e.ip),
                                    onTap: () => {deviceClicked(e)},
                                  )))
                              .toList(),
                        ))))),
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
