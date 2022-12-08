import 'dart:convert';
import 'dart:io';

import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';
import 'package:bk_gps_monitoring/models/GnssSdrController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bk_gps_monitoring/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/utils/ColorConstant.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:bk_gps_monitoring/models/ChartDataPowerStrength.dart';

class PowerStrengthChart extends StatefulWidget {
  PowerStrengthChart({Key? key, required this.gnssSdrController}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  _PowerStrengthChartState createState() => _PowerStrengthChartState();
}

class _PowerStrengthChartState extends State<PowerStrengthChart> {
  late PowerStrengthProvider _powerStrengthProvider;
  late bool _init = false;

  // static final _newLinuxPlugin = NewLinuxPlugin();
  // late GnssSdrController gnssSdrController;
  // late bool messageQueueAvailable = false;
  // late bool loop = false;
  // late bool isSending = false;
  String? result = "";

  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
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
    _powerStrengthProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 1), () async {
        _powerStrengthProvider.initData();
        _powerStrengthProvider.updateValue({});
        _init = true;
      });
    }
    // _powerStrengthProvider = context.watch<PowerStrengthProvider>();
    super.didChangeDependencies();
  }

  void loopReceiver() async {
    _powerStrengthProvider.initData();
    widget.gnssSdrController.loop = true;
    // int start, end, dif;
    int errorCount = 0;
    while(widget.gnssSdrController.loop) {
      widget.gnssSdrController.sendData();
      // start = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(const Duration(milliseconds: 980), () async {
        try {
          final String? result = await widget.gnssSdrController.receiveCN0();
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
              _powerStrengthProvider.initData();
              _powerStrengthProvider.updateValue(json.decode(result));
              // Map<String, dynamic> data_list = json.decode(result);
              // for(var item in data_list.entries){
              //   double CN0 = item.value;
              //   if(CN0 > 0) data[int.parse(item.key)-1].y = CN0;
              // }
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
              )
            ),
            Expanded(
              child: Container(
                  width: 1000,
                  // margin: const EdgeInsets.all(10.0),
                  // padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                  ),
                child: SfCartesianChart(
                  backgroundColor: Colors.white,
                  plotAreaBorderWidth: 0.9,
                  plotAreaBorderColor: Colors.white,
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
                  series: <ChartSeries<ChartDataPowerStrength, String>>[
                    ColumnSeries<ChartDataPowerStrength, String>(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      dataSource: _powerStrengthProvider.data,
                      isVisible: true,
                      isVisibleInLegend: true,
                      legendItemText: "C/N0 index\nof each \nSatelite (dB)",
                      legendIconType: LegendIconType.rectangle,
                      // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                      xValueMapper: (ChartDataPowerStrength data, _) => data.x,
                      yValueMapper: (ChartDataPowerStrength data, _) => data.y,
                      name: 'dB',
                      color: Colors.blueAccent,
                    )
                  ]   
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}