import 'package:flutter/material.dart';
import 'package:unofficial_roku_remote/pages/devices.dart';
import 'package:unofficial_roku_remote/pages/remote.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const c = Color.fromARGB(255, 123, 0, 206);
    return Drawer(
      child: Container(
        color: c,
        child: ListView(
          children: [
            const SizedBox(height: 48),
            buildMenuItem(label: 'Devices', context: context),
            buildMenuItem(label: 'Remote', context: context),
            buildMenuItem(label: 'Settings', context: context)
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String label, required BuildContext context}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;
    return ListTile(
      hoverColor: hoverColor,
      onTap: () => {
        if (label == 'Devices')
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DevicePage()))
          }
        else if (label == 'Remote')
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RemotePage()))
          }
        else if (label == 'Settings')
          {}
      },
      title: Text(label, style: const TextStyle(color: color)),
    );
  }
}
