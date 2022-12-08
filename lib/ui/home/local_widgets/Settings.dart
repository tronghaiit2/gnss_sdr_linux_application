import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';
import 'package:bk_gps_monitoring/models/GnssSdrController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';
import 'package:bk_gps_monitoring/models/ChartDataPowerStrength.dart';

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

  void initData() {

  }

  void loopReceiver() async {
    initData();
    widget.gnssSdrController.loop = true;
    int errorCount = 0;
    // int start, end, dif;
    while(widget.gnssSdrController.loop) {
      widget.gnssSdrController.sendData();
      // start = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(const Duration(milliseconds: 975), () async {
        try {
          final String? result = await widget.gnssSdrController.receiveData();
          DateTime dateTime = DateTime.now();
          if(result != null) {
            if(result == "end") {
              errorCount++;
              if(errorCount > 4) {
                widget.gnssSdrController.isSending = false;
                widget.gnssSdrController.loop = false;
                // ignore: use_build_context_synchronously
                showWarningDialog("Can not receive GPS signal!", context);
              }
            } else {
              if (kDebugMode) {
                print(result);
              }
              setState(() {

              });
            }
          } else {
            errorCount++;
            if(errorCount > 4) {
              widget.gnssSdrController.isSending = false;
              widget.gnssSdrController.loop = false;
              // ignore: use_build_context_synchronously
              showWarningDialog("Can not receive GPS signal!", context);
            }
          }
        } on Exception catch (e) {
          widget.gnssSdrController.isSending = false;
          widget.gnssSdrController.loop = false;
        } 
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blueGrey,
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50,),
                confirmButton("Init MessageQueue", (){
                  widget.gnssSdrController.initMessageQueue();
                  widget.gnssSdrController.messageQueueAvailable = true;
                }),
                SizedBox(height: 25,),
                confirmButton("Send Data", () async {
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
                confirmButton("Start GPS_SDR", (){
                    if(widget.gnssSdrController.loop) {
                    showWarningDialog("Please waiting for end of Message Queue, then start again", context);
                  }
                  else {
                  if(widget.gnssSdrController.messageQueueAvailable) {
                    if(widget.gnssSdrController.isSending) {
                      loopReceiver();
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
                confirmButton("Stop receive Data", () async {
                  widget.gnssSdrController.isSending = false;
                  widget.gnssSdrController.loop = false;
                  // await _endData();
                }),
                SizedBox(height: 25,),
                confirmButton("Clear MessageQueue", (){
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
            ),
          ),
          Expanded(
            child: settings(),
          ),
        ],
      )
    );
  }

   Widget settings() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select GPS Satellite"),
        centerTitle: false,
        toolbarHeight: 50,
      ),
      body: Container(
          width: 1000,
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
          ),
        ),
    );
  }
}
