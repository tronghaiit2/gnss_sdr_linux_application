import 'package:flutter/material.dart';

import 'package:bk_gps_monitoring/models/GnssSdrController.dart';

class Settings extends StatefulWidget {
  Settings({Key? key, required this.gnssSdrController}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // late widget.gnssSdrController widget.gnssSdrController;

  // late bool messageQueueAvailable = false;
  // late bool loop = false;
  // late bool isSending = false;

  @override
  void initState() {
    // gnssSdrController = widget.gnssSdrController;
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: settings(),
          ),
        ],
      )
    );
  }

   Widget settings() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Select GPS Satellite",
          style: TextStyle(fontSize: 14),),
        centerTitle: false,
        toolbarHeight: 30,
      ),
      body: Container(
          // width: 1000,
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
          ),
        ),
    );
  }
}
