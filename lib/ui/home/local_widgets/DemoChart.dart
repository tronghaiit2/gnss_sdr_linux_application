import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';
import 'package:bk_gps_monitoring/provider/DemoProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';
import 'package:bk_gps_monitoring/models/GnssSdrController.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/MultiChoice.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';
import 'package:bk_gps_monitoring/utils/ColorConstant.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DemoChart extends StatefulWidget {
  DemoChart({Key? key, required this.gnssSdrController}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  _DemoChartState createState() => _DemoChartState();
}

class _DemoChartState extends State<DemoChart> {
  late DemoProvider _demoProvider;
  late bool _init = false;

  // static final _newLinuxPlugin = NewLinuxPlugin();
  // late GnssSdrController gnssSdrController;
  // late bool messageQueueAvailable = false;
  // late bool loop = false;
  // late bool isSending = false;

  // late List<List<ChartDataDemo>> data;
  late TooltipBehavior _tooltip;

  // late List<String> gpsPRNSelectedList;
  // late int itemsSelected = 1;
  
  @override
  void initState() {
    super.initState();
    // initData();
    // gnssSdrController = GnssSdrController(newLinuxPlugin: _newLinuxPlugin);
    if(widget.gnssSdrController.messageQueueAvailable && widget.gnssSdrController.isSending) {
      loopReceiver();
    }
    _tooltip = TooltipBehavior(enable: true);
  }


  @override
  void dispose() {
    _init = false;
    widget.gnssSdrController.messageQueueAvailable = false;
    widget.gnssSdrController.loop = false;
    widget.gnssSdrController.isSending = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _demoProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 1), () async {
        _demoProvider.initData();
        _demoProvider.updateValue({});
        _init = true;
      });
    }
    // _powerStrengthProvider = context.watch<PowerStrengthProvider>();
    super.didChangeDependencies();
  }

  // void sendData(String file) {
  //   String cmd =  "assets/tmp/$file";
  //   Process.run(cmd, []);
  // }

  void loopReceiver() async {
    _demoProvider.initData();
    widget.gnssSdrController.loop = true;
    // int start, end, dif;
    int errorCount = 0;
    while(widget.gnssSdrController.loop) {
      widget.gnssSdrController.sendData();
      // start = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(const Duration(milliseconds: 975), () async {
        try {
          // final String? result = await _receiveData();
          // final String? result = await _receiveCN0();
          final String? result = await widget.gnssSdrController.receivePromptI();
          // final String? result = await widget.gnssSdrController.receivePromptQ();
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
              errorCount = 0;
              _demoProvider.updateValue(json.decode(result));
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
          // end = DateTime.now().millisecondsSinceEpoch;
          // dif = 1000 - (end - start);
          // if(dif > 0) {
          //   Future.delayed(Duration(milliseconds:  dif), () => {
          //   });
          // }
        } on Exception catch (e) {
          widget.gnssSdrController.isSending = false;
          widget.gnssSdrController.loop = false;
        } 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!_init) {
      return const Center(
        child: SpinKitCircle(
          color: AppColors.main_red,
          size: 50,
        ),
      );
    } else {
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
              child: diagram(),
            ),
          ],
        )
      );
    }
  }

  Widget diagram() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select GPS Satellite"),
        centerTitle: false,
        toolbarHeight: 50,
      ),
      drawer: drawer(),
      body: Container(
          width: 1000,
          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
          ),
          child: SfCartesianChart(
            plotAreaBorderWidth: 0.9,
            primaryXAxis: DateTimeAxis(
              title: AxisTitle(text: "Times"),
              intervalType: DateTimeIntervalType.seconds,
              minimum: _demoProvider.data[0].elementAt(0).x,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: "C/N0 (dB)"),
              // minimum: -200000
              // interval: 10
            ),
            legend: Legend(
              isVisible: true,
              alignment: ChartAlignment.near
            ),
            tooltipBehavior: _tooltip,
            series: 
            _demoProvider.itemsSelected < 2 ? 
            <ChartSeries<ChartDataDemo, DateTime>>[
              LineSeries<ChartDataDemo, DateTime>(
                dataSource: _demoProvider.data[0],
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "C/N0 index of\neach Satelite (dB)",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataDemo data, _) => data.x,
                yValueMapper: (ChartDataDemo data, _) => data.y,
                name: 'dB',),
            ] : 
            <ChartSeries<ChartDataDemo, DateTime>>[
              for(int i = 1; i < _demoProvider.itemsSelected; i++) 
              LineSeries<ChartDataDemo, DateTime>(
                dataSource: _demoProvider.data[i],
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "C/N0 index of\nSatelite ${_demoProvider.gpsPRNSelectedList[i-1]} (dB)",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataDemo data, _) => data.x,
                yValueMapper: (ChartDataDemo data, _) => data.y,
                animationDuration: 0,
                name: 'dB',),
            ]
          ),
        ),
    );
  }

  Widget drawer() {
    return Container(
        height: 300,
        width: 1280,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 2)
        ),
        child: MultiChoice(
          onSelectParam: (HashSet<String> selectedList) {
            // do something with param
            _demoProvider.gpsPRNSelectedList = selectedList.toList();
            _demoProvider.itemsSelected = _demoProvider.gpsPRNSelectedList.length + 1;
            _demoProvider.gpsPRNSelectedList.sort();
            loopReceiver();
            Navigator.pop(context);
            print(_demoProvider.gpsPRNSelectedList.toString());
          }
        ),
      );
  }
}
