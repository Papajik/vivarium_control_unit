import 'package:flutter/material.dart';

class AddLocation extends StatelessWidget {
  final String uid;

  AddLocation({Key key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new location"),
      ),
      body: Text("Add new location")
    );
  }

}
