import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/models/ChartDataPowerStrength.dart';

class PowerStrengthProvider extends ChangeNotifier{
  late List<ChartDataPowerStrength> data;

  void initData() {
    data = [
      ChartDataPowerStrength('01', 0),
      ChartDataPowerStrength('02', 0),
      ChartDataPowerStrength('03', 0),
      ChartDataPowerStrength('04', 0),
      ChartDataPowerStrength('05', 0),
      ChartDataPowerStrength('06', 0),
      ChartDataPowerStrength('07', 0),
      ChartDataPowerStrength('08', 0),
      ChartDataPowerStrength('09', 0),
      ChartDataPowerStrength('10', 0),
      ChartDataPowerStrength('11', 0),
      ChartDataPowerStrength('12', 0),
      ChartDataPowerStrength('13', 0),
      ChartDataPowerStrength('14', 0),
      ChartDataPowerStrength('15', 0),
      ChartDataPowerStrength('16', 0),
      ChartDataPowerStrength('17', 0),
      ChartDataPowerStrength('18', 0),
      ChartDataPowerStrength('19', 0),
      ChartDataPowerStrength('20', 0),
      ChartDataPowerStrength('21', 0),
      ChartDataPowerStrength('22', 0),
      ChartDataPowerStrength('23', 0),
      ChartDataPowerStrength('24', 0),
      ChartDataPowerStrength('25', 0),
      ChartDataPowerStrength('26', 0),
      ChartDataPowerStrength('27', 0),
      ChartDataPowerStrength('28', 0),
      ChartDataPowerStrength('29', 0),
      ChartDataPowerStrength('30', 0),
      ChartDataPowerStrength('31', 0),
      ChartDataPowerStrength('32', 0),
    ];
    // notifyListeners();
  }

  void updateValue(Map<String, dynamic> dataList) {
    for(var item in dataList.entries){
      double CN0 = item.value;
      if(CN0 > 0) data[int.parse(item.key)-1].y = CN0;
    }
    notifyListeners();
  }
}

