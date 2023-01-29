import 'package:flutter/material.dart';

import 'package:bk_gps_monitoring/controller/GnssSdrController.dart';

import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';


class GPSController extends StatefulWidget {
  Function() loopReceiver;
  GPSController({Key? key, required this.gnssSdrController, required this.loopReceiver}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  State<GPSController> createState() => _GPSControllerState();
}

class _GPSControllerState extends State<GPSController> {
  // late widget.gnssSdrController widget.gnssSdrController;
  // late bool messageQueueAvailable = false;
  // late bool loop = false;
  // late bool isSending = false;
  String str = "Hello";

  @override
  void initState() {
    // gnssSdrController = widget.gnssSdrController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Container(
      color: Colors.blueGrey,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50,),
          confirmButton("Init", (){
            widget.gnssSdrController.initMessageQueue();
            widget.gnssSdrController.messageQueueAvailable = true;
          }),
          SizedBox(height: 25,),
          confirmButton("Send", () async {
            if(widget.gnssSdrController.loop) {
              showWarningDialog("Please waiting for end of data before", context);
            }
            else {
              if(widget.gnssSdrController.messageQueueAvailable) {
                // final dir = await getTemporaryDirectory();
                // Process.run("${dir.path}/assets/tmp/send", []);
                // Process.run("assets/tmp/send", []);
                // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-GNSS-SDR-receiver.conf"]);
                // _sendData();
                widget.gnssSdrController.isSending = true;
              }
            }
          }),
          SizedBox(height: 25,),
          confirmButton("Start", (){
            if(widget.gnssSdrController.loop) {
              showWarningDialog("Please waiting for end of Message Queue, then start again", context);
            }
            else {
            if(widget.gnssSdrController.messageQueueAvailable) {
              if(widget.gnssSdrController.isSending) {
                widget.loopReceiver();
              }
              else {
                showConfirmDialog("Not available to send data", "Start to send data by click \"Start\" and Start GPS_SDR again", 
                () async {
                  // final dir = await getTemporaryDirectory();
                  // Process.run("${dir.path}/assets/tmp/send", []);
                  // Process.run("assets/tmp/send", []);
                  // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-GNSS-SDR-receiver.conf"]);
                  widget.gnssSdrController.isSending = true;
                }, 
                (){}, context, "Start", "Cancel");
              }
            }
            else {
              showConfirmDialog("Please Init MessageQueue", "init MessageQueue by click \"Init\" and Start GPS_SDR again", 
              (){
                if(!widget.gnssSdrController.messageQueueAvailable) {
                  widget.gnssSdrController.initMessageQueue();
                  widget.gnssSdrController.messageQueueAvailable = true; 
                }
              }, 
              (){}, context, "Init", "Cancel");
            }
            }
          }),
          SizedBox(height: 25,),
          confirmButton("Stop", () async {
            widget.gnssSdrController.isSending = false;
            widget.gnssSdrController.loop = false;
            // await _endData();
          }),
          SizedBox(height: 25,),
          confirmButton("End", (){
            if(widget.gnssSdrController.loop) {
              showWarningDialog("Please waiting for end of Message Queue, then clear queue", context);
            }
            else {
              if(widget.gnssSdrController.messageQueueAvailable) {
                widget.gnssSdrController.endMessageQueue();
                widget.gnssSdrController.messageQueueAvailable = false;
              }
            }
          }),
        ],
      )
    );
  }
}
