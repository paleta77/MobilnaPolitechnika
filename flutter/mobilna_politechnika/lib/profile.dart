import 'package:flutter/material.dart';

import 'locale.dart';
import 'side-drawer.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locale.current['profile']),
      ),
      drawer: SideDrawer(),
      body: Center(

      ),
    );
  }
}
