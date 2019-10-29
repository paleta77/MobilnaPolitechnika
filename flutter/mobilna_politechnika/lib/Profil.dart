import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      drawer: MyDrawer(),
      body: Center(

      ),
    );
  }
}
