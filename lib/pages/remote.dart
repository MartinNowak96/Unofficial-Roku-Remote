import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '../widget/navifation_drawer_widget.dart';
import 'package:xml/xml.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({Key? key}) : super(key: key);

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  String ipAddress = '';
  final LocalStorage storage = LocalStorage('roku');

  @override
  void initState() {
    super.initState();
    storage.ready.then((value) {
      var ip = storage.getItem('selectedDeviceIp');
      if (ip != null) {
        ipAddress = ip;
        getApps();
      }
    });
  }

  void keyPressed(RawKeyEvent keyEvent) {
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      buttonPressed('up');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      buttonPressed('down');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      buttonPressed('left');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      buttonPressed('right');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.audioVolumeUp)) {
      buttonPressed('volumeup');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.audioVolumeDown)) {
      buttonPressed('volumedown');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.enter)) {
      buttonPressed('select');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.home) ||
        keyEvent.isKeyPressed(LogicalKeyboardKey.goHome)) {
      buttonPressed('home');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.goBack) ||
        keyEvent.isKeyPressed(LogicalKeyboardKey.backspace)) {
      buttonPressed('back');
    } else if (keyEvent.isKeyPressed(LogicalKeyboardKey.audioVolumeMute)) {
      buttonPressed('mute');
    }
  }

  Future<void> getApps() async {
    if (ipAddress == '') {
      return;
    }

    var url = Uri.parse('http://' + ipAddress + ':8060/query/apps');
    var response = await http.post(url);
    if (response.statusCode <= 200 && response.statusCode < 400) {
      final document = XmlDocument.parse(response.body);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> buttonPressed(String key) async {
    if (ipAddress == '') {
      return;
    }

    var url = Uri.parse('http://' + ipAddress + ':8060/keypress/' + key);
    var response = await http.post(url);
    if (kDebugMode) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: keyPressed,
      autofocus: true,
      child: Scaffold(
        drawer: const NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Roku Remote'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () => {buttonPressed('power')},
                  child: const Icon(Icons.power_settings_new_outlined)),
              GestureDetector(
                  onTap: () => {buttonPressed('home')},
                  child: const Icon(Icons.home)),
              GestureDetector(
                  onTap: () => {buttonPressed('up')},
                  child: const Icon(Icons.keyboard_arrow_up_rounded)),
              GestureDetector(
                  onTap: () => {buttonPressed('left')},
                  child: const Icon(Icons.keyboard_arrow_left_rounded)),
              GestureDetector(
                  onTap: () => {buttonPressed('right')},
                  child: const Icon(Icons.keyboard_arrow_right_rounded)),
              GestureDetector(
                  onTap: () => {buttonPressed('down')},
                  child: const Icon(Icons.keyboard_arrow_down_rounded)),
              GestureDetector(
                  onTap: () => {buttonPressed('volumedown')},
                  child: const Icon(Icons.volume_down)),
              GestureDetector(
                  onTap: () => {buttonPressed('volumeup')},
                  child: const Icon(Icons.volume_up)),
              GestureDetector(
                  onTap: () => {buttonPressed('volumemute')},
                  child: const Icon(Icons.volume_mute)),
            ],
          ),
        ),
      ));
}
