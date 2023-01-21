import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


import 'package:bk_gps_monitoring/utils/ColorConstant.dart';

import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';
import 'package:bk_gps_monitoring/models/GnssSdrController.dart';

import 'package:bk_gps_monitoring/provider/DemoProvider.dart';

import 'package:bk_gps_monitoring/ui/home/local_widgets/MultiChoice.dart';


class DemoChart extends StatefulWidget {
  late DemoProvider demoProvider;
  DemoChart({Key? key, required this.gnssSdrController, required this.demoProvider}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  State<DemoChart>  createState() => _DemoChartState();
}

class _DemoChartState extends State<DemoChart> {
  // late DemoProvider widget.demoProvider;
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
    _tooltip = TooltipBehavior(enable: true);
  }


  @override
  void dispose() {
    super.dispose();
    // _init = false;
    // widget.gnssSdrController.messageQueueAvailable = false;
    // widget.gnssSdrController.loop = false;
    // widget.gnssSdrController.isSending = false;
  }

  @override
  void didChangeDependencies() {
    widget.demoProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 0), () async {
        widget.demoProvider.initData();
        widget.demoProvider.updateValue({}, {});
        _init = true;
      });

      // if(widget.gnssSdrController.messageQueueAvailable && widget.gnssSdrController.isSending) {
      //   loopReceiver();
      // }
    }

    super.didChangeDependencies();
  }

  // void sendData(String file) {
  //   String cmd =  "assets/tmp/$file";
  //   Process.run(cmd, []);
  // }

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
      backgroundColor: Colors.white,
      drawer: drawer(),
      appBar: AppBar(
        title: Text("Select GPS Satellite", 
          style: TextStyle(fontSize: 14),),
        centerTitle: false,
        toolbarHeight: 30,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 16, // Changing Drawer Icon Size
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
          ),
          child: SfCartesianChart(
            backgroundColor: Colors.white,
            plotAreaBorderWidth: 0.9,
            plotAreaBorderColor: Colors.white,
            primaryXAxis: DateTimeAxis(
              labelStyle: TextStyle(color: Colors.black),
              title: AxisTitle(text: "Times"),
              intervalType: DateTimeIntervalType.seconds,
              minimum: widget.demoProvider.data_0.elementAt(0).x,
            ),
            primaryYAxis: NumericAxis(
              labelStyle: TextStyle(color: Colors.black),
              title: AxisTitle(text: "S4 index"),
              // minimum: -200000
              // interval: 10
            ),
            legend: Legend(
              isVisible: true,
              alignment: ChartAlignment.near
            ),
            tooltipBehavior: _tooltip,
            series: 
            widget.demoProvider.itemsSelected == 0 ? 
            <ChartSeries<ChartDataDemo, DateTime>>[
              LineSeries<ChartDataDemo, DateTime>(
                dataSource: widget.demoProvider.data_0,
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "S4",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataDemo data, _) => data.x,
                yValueMapper: (ChartDataDemo data, _) => data.y,
                name: 'S4',),
            ] : 
            <ChartSeries<ChartDataDemo, DateTime>>[
              for(int i = 0; i < widget.demoProvider.itemsSelected; i++) 
              LineSeries<ChartDataDemo, DateTime>(
                dataSource: widget.demoProvider.data[i],
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "${widget.demoProvider.gpsPRNSelectedList[i]}",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataDemo data, _) => data.x,
                yValueMapper: (ChartDataDemo data, _) => data.y,
                animationDuration: 0,
                name: 'S4',),
              // for(int i = 0; i < widget.demoProvider.itemsSelected; i++) 
              // LineSeries<ChartDataDemo, DateTime>(
              //   dataSource: widget.demoProvider.channelI[i],
              //   isVisible: true,
              //   isVisibleInLegend: true,
              //   legendItemText: "Channel I\nof Satelite ${widget.demoProvider.gpsPRNSelectedList[i]}",
              //   legendIconType: LegendIconType.rectangle,
              //   // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
              //   xValueMapper: (ChartDataDemo data, _) => data.x,
              //   yValueMapper: (ChartDataDemo data, _) => data.y,
              //   animationDuration: 0,
              //   name: 'I',),
              // for(int i = 0; i < widget.demoProvider.itemsSelected; i++) 
              // LineSeries<ChartDataDemo, DateTime>(
              //   dataSource: widget.demoProvider.channelQ[i],
              //   isVisible: true,
              //   isVisibleInLegend: true,
              //   legendItemText: "Channel Q\nof Satelite ${widget.demoProvider.gpsPRNSelectedList[i]}",
              //   legendIconType: LegendIconType.rectangle,
              //   // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
              //   xValueMapper: (ChartDataDemo data, _) => data.x,
              //   yValueMapper: (ChartDataDemo data, _) => data.y,
              //   animationDuration: 0,
              //   name: 'Q',),
            ]
          ),
        ),
    );
  }

  Widget drawer() {
    return Container(
        height: 320,
        width: 600,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 2)
        ),
        child: MultiChoice(
          onSelectParam: (HashSet<String> selectedList) {
            // do something with param
            widget.demoProvider.gpsPRNSelectedList = selectedList.toList();
            widget.demoProvider.itemsSelected = widget.demoProvider.gpsPRNSelectedList.length;
            widget.demoProvider.gpsPRNSelectedList.sort();
            widget.demoProvider.initData();
            Navigator.pop(context);
            print(widget.demoProvider.gpsPRNSelectedList.toString());
          }
        ),
      );
  }
}
