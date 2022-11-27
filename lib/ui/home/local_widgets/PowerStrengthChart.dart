import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/utils/ColorConstant.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PowerStrengthChart extends StatefulWidget {
  PowerStrengthChart({Key? key}) : super(key: key);

  @override
  _PowerStrengthChartState createState() => _PowerStrengthChartState();
}

class _PowerStrengthChartState extends State<PowerStrengthChart> {
  late PowerStrengthProvider _powerStrengthProvider;
  late bool _init = false;

  static final _newLinuxPlugin = NewLinuxPlugin();
  late bool messageQueueAvailable = false;
  late bool loop = false;
  late bool isSending = false;
  String? result = "";

  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  void dispose() {
    _init = false;
    messageQueueAvailable = false;
    loop = false;
    isSending = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _powerStrengthProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(Duration(seconds: 2), () async {
        _powerStrengthProvider.initData();
        _powerStrengthProvider.updateValue({});
        _init = true;
      });
    }
    // _powerStrengthProvider = context.watch<PowerStrengthProvider>();
    super.didChangeDependencies();
  }

  Future<bool?> _initMessageQueue() async {
    bool init;
    try {
      init =
          await _newLinuxPlugin.initMessageQueue() ?? false;
    } on Exception {
      init = false;
    }
    return init;
  }

  Future<bool?> _endMessageQueue() async {
    bool end;
    try {
      end =
          await _newLinuxPlugin.endMessageQueue() ?? false;
    } on Exception {
      end = false;
    }
    return end;
  }

 Future<String?> _receiveData() async {
    String? receiveData;
    try {
      receiveData =
          await _newLinuxPlugin.receiveData().timeout(Duration(seconds: 1));
    } on Exception {
      receiveData = null;
    }
    return receiveData;
  }


  void _sendData() async {
    _newLinuxPlugin.sendData();
  }

  Future<bool?> _endData() async {
    bool endData;
    try {
      endData =
          await _newLinuxPlugin.endData() ?? false;
    } on Exception {
      endData = false;
    }
    return endData;
  }

  void loopReceiver() async {
    loop = true;
    // int start, end, dif;
    int errorCount = 0;
    while(loop) {
      _sendData();
      // start = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(const Duration(milliseconds: 980), () async {
        try {
          final String? result = await _receiveData();
          if(result != null) {
            if(result == "end") {
              errorCount++;
              if(errorCount > 4) {
                isSending = false;
                loop = false;
                // ignore: use_build_context_synchronously
                showWarningDialog("Can not receive GPS signal!", context);
              }
            } else {
              errorCount = 0;
              if(_powerStrengthProvider != null) {
                _powerStrengthProvider.initData();
                _powerStrengthProvider.updateValue(json.decode(result));
              }
              // Map<String, dynamic> data_list = json.decode(result);
              // for(var item in data_list.entries){
              //   double CN0 = item.value;
              //   if(CN0 > 0) data[int.parse(item.key)-1].y = CN0;
              // }
            }
          } else {
            errorCount++;
            if(errorCount > 4) {
              isSending = false;
              loop = false;
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
          isSending = false;
          loop = false;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'GNSS_GPS_SDR',
                  ),
                  SizedBox(height: 20,),
                  confirmButton("Init MessageQueue", (){
                    _initMessageQueue();
                    messageQueueAvailable = true;
                  }),
                  SizedBox(height: 20,),
                  confirmButton("Send Data", () async {
                    if(loop) {
                      showWarningDialog("Please waiting for end of data before", context);
                    }
                    else {
                      if(messageQueueAvailable) {
                        // final dir = await getTemporaryDirectory();
                        // Process.run("${dir.path}/assets/tmp/send", []);
                        // Process.run("assets/tmp/send", []);
                        // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-GNSS-SDR-receiver.conf"]);
                        // _sendData();
                        isSending = true;
                      }
                    }
                  }),
                  SizedBox(height: 20,),
                  confirmButton("Start GPS_SDR", (){
                      if(loop) {
                      showWarningDialog("Please waiting for end of Message Queue, then start again", context);
                    }
                    else {
                    if(messageQueueAvailable) {
                      if(isSending) {
                        loopReceiver();
                      }
                      else {
                        showConfirmDialog("Not available to send data", "Start to send data by click \"Start\" and Start GPS_SDR again", 
                        () async {
                          // final dir = await getTemporaryDirectory();
                          // Process.run("${dir.path}/assets/tmp/send", []);
                          // Process.run("assets/tmp/send", []);
                          // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-GNSS-SDR-receiver.conf"]);
                          isSending = true;
                        }, 
                        (){}, context, "Start", "Cancel");
                      }
                    }
                    else {
                      showConfirmDialog("Please Init MessageQueue", "init MessageQueue by click \"Init\" and Start GPS_SDR again", 
                      (){
                        if(!messageQueueAvailable) {
                          _initMessageQueue();
                          messageQueueAvailable = true; 
                        }
                      }, 
                      (){}, context, "Init", "Cancel");
                    }
                    }
                  }),
                  SizedBox(height: 20,),
                  confirmButton("Stop receive Data", () async {
                    isSending = false;
                    loop = false;
                    // await _endData();
                  }),
                  SizedBox(height: 20,),
                  confirmButton("Clear MessageQueue", (){
                    if(loop) {
                      showWarningDialog("Please waiting for end of Message Queue, then clear queue", context);
                    }
                    else {
                      if(messageQueueAvailable) {
                        _endMessageQueue();
                        messageQueueAvailable = false;
                      }
                    }
                  }),
                ],
              )
            ),
            Expanded(
              child: Container(
                  width: 1000,
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                  ),
                child: SfCartesianChart(
                  backgroundColor: Colors.blueGrey,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Colors.white),
                  title: AxisTitle(text: "Satelite")
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Colors.white),
                  title: AxisTitle(text: "C/N0 (dB)"),
                  minimum: 0, interval: 10
                ),
                legend: Legend(
                  isVisible: true,
                  alignment: ChartAlignment.near
                ),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      dataSource: _powerStrengthProvider.data,
                      isVisible: true,
                      isVisibleInLegend: true,
                      legendItemText: "C/N0 index\nof each \nSatelite (dB)",
                      legendIconType: LegendIconType.rectangle,
                      // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'dB',
                      color: Colors.blueAccent,
                      )
                ]),
              ),
            )
          ],
        ),
      );
    }
  }
}