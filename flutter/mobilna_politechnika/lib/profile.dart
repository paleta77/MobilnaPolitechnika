import 'package:flutter/material.dart';

import 'locale.dart';
import 'side-drawer.dart';
import 'user.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locale.current['profile']),
      ),
      drawer: SideDrawer(),
      body: Center(
          child: Text("name: " +
              User.instance.name +
              '\nmail: ' +
              User.instance.mail +
              '\ngroup: ' +
              User.instance.group)),
    );
  }
}
