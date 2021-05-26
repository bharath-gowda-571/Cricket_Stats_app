import 'dart:async';

import 'package:flutter/material.dart';

class StadiumInfo extends StatefulWidget {
  final stadium_info;
  final stadium_name;
  final city;
  StadiumInfo(this.stadium_info, this.stadium_name, this.city, {Key key})
      : super(key: key);
  @override
  _StadiumInfoState createState() => _StadiumInfoState();
}

class _StadiumInfoState extends State<StadiumInfo> {
  @override
  Widget build(BuildContext context) {
    // print(widget.stadium_info);
    var info = widget.stadium_info;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stadium_name),
      ),
    );
  }
}
