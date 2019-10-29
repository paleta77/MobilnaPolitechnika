import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      drawer: MyDrawer(),
      body: Center(

      ),
    );
  }
}