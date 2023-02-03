import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


import 'package:bk_gps_monitoring/utils/AppColors.dart';

import 'package:bk_gps_monitoring/models/ChartDataS4Index.dart';
import 'package:bk_gps_monitoring/controller/GnssSdrController.dart';

import 'package:bk_gps_monitoring/provider/S4IndexProvider.dart';

import 'package:bk_gps_monitoring/ui/home/local_widgets/SelectSVs.dart';


class S4IndexChart extends StatefulWidget {
  late S4IndexProvider s4indexProvider;
  S4IndexChart({Key? key, required this.gnssSdrController, required this.s4indexProvider}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  State<S4IndexChart>  createState() => _S4IndexChartState();
}

class _S4IndexChartState extends State<S4IndexChart> {
  // late s4indexProvider widget.s4indexProvider;
  late bool _init = false;

  // static final _newLinuxPlugin = NewLinuxPlugin();
  // late GnssSdrController gnssSdrController;
  // late bool messageQueueAvailable = false;
  // late bool loop = false;
  // late bool isSending = false;

  // late List<List<ChartDataS4Index>> data;
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
    widget.s4indexProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 0), () async {
        widget.s4indexProvider.initData();
        widget.s4indexProvider.updateData({});
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
              minimum: widget.s4indexProvider.data_0.elementAt(0).x,
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
            widget.s4indexProvider.itemsSelected == 0 ? 
            <ChartSeries<ChartDataS4Index, DateTime>>[
              LineSeries<ChartDataS4Index, DateTime>(
                dataSource: widget.s4indexProvider.data_0,
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "S4",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataS4Index data, _) => data.x,
                yValueMapper: (ChartDataS4Index data, _) => data.y,
                name: 'S4',),
            ] : 
            <ChartSeries<ChartDataS4Index, DateTime>>[
              for(int i = 0; i < widget.s4indexProvider.itemsSelected; i++) 
              LineSeries<ChartDataS4Index, DateTime>(
                dataSource: widget.s4indexProvider.data[i],
                isVisible: true,
                isVisibleInLegend: true,
                legendItemText: "${widget.s4indexProvider.gpsPRNSelectedList[i]}",
                legendIconType: LegendIconType.rectangle,
                // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
                xValueMapper: (ChartDataS4Index data, _) => data.x,
                yValueMapper: (ChartDataS4Index data, _) => data.y,
                animationDuration: 0,
                name: 'S4',),
              // for(int i = 0; i < widget.s4indexProvider.itemsSelected; i++) 
              // LineSeries<ChartDataS4Index, DateTime>(
              //   dataSource: widget.s4indexProvider.channelI[i],
              //   isVisible: true,
              //   isVisibleInLegend: true,
              //   legendItemText: "Channel I\nof Satelite ${widget.s4indexProvider.gpsPRNSelectedList[i]}",
              //   legendIconType: LegendIconType.rectangle,
              //   // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
              //   xValueMapper: (ChartDataS4Index data, _) => data.x,
              //   yValueMapper: (ChartDataS4Index data, _) => data.y,
              //   animationDuration: 0,
              //   name: 'I',),
              // for(int i = 0; i < widget.s4indexProvider.itemsSelected; i++) 
              // LineSeries<ChartDataS4Index, DateTime>(
              //   dataSource: widget.s4indexProvider.channelQ[i],
              //   isVisible: true,
              //   isVisibleInLegend: true,
              //   legendItemText: "Channel Q\nof Satelite ${widget.s4indexProvider.gpsPRNSelectedList[i]}",
              //   legendIconType: LegendIconType.rectangle,
              //   // selectionBehavior: SelectionBehavior(enable: true, selectedColor: Colors.red, unselectedColor: Colors.blueAccent),
              //   xValueMapper: (ChartDataS4Index data, _) => data.x,
              //   yValueMapper: (ChartDataS4Index data, _) => data.y,
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
        child: SelectSVs(
          onSelectParam: (HashSet<String> selectedList) {
            // do something with param
            widget.s4indexProvider.gpsPRNSelectedList = selectedList.toList();
            widget.s4indexProvider.itemsSelected = widget.s4indexProvider.gpsPRNSelectedList.length;
            widget.s4indexProvider.gpsPRNSelectedList.sort();
            setState(() {
              widget.s4indexProvider.initData();
              Navigator.pop(context);
              print(widget.s4indexProvider.gpsPRNSelectedList.toString());
            });
          },
          selectedItems: widget.s4indexProvider.gpsPRNSelectedList,
        ),
      );
  }
}
