import 'package:flutter/material.dart';

import 'package:bk_gps_monitoring/controller/GnssSdrController.dart';

class History extends StatefulWidget {
  History({Key? key, required this.gnssSdrController}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
        title: Text("History diagrams",
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
