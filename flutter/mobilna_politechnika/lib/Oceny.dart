import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';

class Oceny extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oceny"),
      ),
      drawer: MyDrawer(),
      body: Center(

      ),
    );
  }
}