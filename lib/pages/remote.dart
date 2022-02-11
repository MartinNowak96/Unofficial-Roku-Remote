import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widget/navifation_drawer_widget.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({Key? key}) : super(key: key);

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  String ipAddress = '';

  Future<void> buttonPressed(String key) async {
    if (ipAddress == '') {
      return;
    }

    var url = Uri.parse('http://192.168.1.95:8060/keypress/' + key);
    var response = await http.post(url);
    if (kDebugMode) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            ],
          ),
        ),
      );
}
