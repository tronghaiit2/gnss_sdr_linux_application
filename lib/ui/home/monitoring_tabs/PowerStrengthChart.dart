import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:bk_gps_monitoring/utils/ColorConstant.dart';

import 'package:bk_gps_monitoring/controller/GnssSdrController.dart';
import 'package:bk_gps_monitoring/models/ChartDataPowerStrength.dart';

import 'package:bk_gps_monitoring/provider/PowerStrengthProvider.dart';



class PowerStrengthChart extends StatefulWidget {
  late PowerStrengthProvider powerStrengthProvider;
  PowerStrengthChart({Key? key, required this.gnssSdrController, required this.powerStrengthProvider}) : super(key: key);
  final GnssSdrController gnssSdrController;

  @override
  State<PowerStrengthChart>  createState() => _PowerStrengthChartState();
}

class _PowerStrengthChartState extends State<PowerStrengthChart> {
  // late PowerStrengthProvider widget.powerStrengthProvider;
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
    widget.powerStrengthProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 0), () async {
        widget.powerStrengthProvider.initData();
        widget.powerStrengthProvider.updateValue({});
        _init = true;
      });

      // if(widget.gnssSdrController.messageQueueAvailable && widget.gnssSdrController.isSending) {
      //   loopReceiver();
      // }
    }
    super.didChangeDependencies();
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
      body: Row(
        children: [
          Expanded(
            child: Container(
              width: 500,
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
              ),
              child: SfCartesianChart(
                backgroundColor: Colors.white,
                plotAreaBorderWidth: 0.9,
                plotAreaBorderColor: Colors.white,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Colors.black),
                  title: AxisTitle(text: "Satelite")
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Colors.black),
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
                    dataSource: widget.powerStrengthProvider.data,
                    isVisible: true,
                    isVisibleInLegend: true,
                    legendItemText: "C/N0\nindex\nof\neach\nSatelite\n(dB)",
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