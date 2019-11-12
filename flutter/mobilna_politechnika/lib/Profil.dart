import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';

import 'locale.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Locale.current['profile']),
      ),
      drawer: MyDrawer(),
      body: Center(

      ),
    );
  }
}
