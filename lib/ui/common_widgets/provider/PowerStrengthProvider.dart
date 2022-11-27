import 'package:flutter/material.dart';

class PowerStrengthProvider extends ChangeNotifier{
  late List<ChartData> data;

  void initData() {
    data = [
      ChartData('01', 0),
      ChartData('02', 0),
      ChartData('03', 0),
      ChartData('04', 0),
      ChartData('05', 0),
      ChartData('06', 0),
      ChartData('07', 0),
      ChartData('08', 0),
      ChartData('09', 0),
      ChartData('10', 0),
      ChartData('11', 0),
      ChartData('12', 0),
      ChartData('13', 0),
      ChartData('14', 0),
      ChartData('15', 0),
      ChartData('16', 0),
      ChartData('17', 0),
      ChartData('18', 0),
      ChartData('19', 0),
      ChartData('20', 0),
      ChartData('21', 0),
      ChartData('22', 0),
      ChartData('23', 0),
      ChartData('24', 0),
      ChartData('25', 0),
      ChartData('26', 0),
      ChartData('27', 0),
      ChartData('28', 0),
      ChartData('29', 0),
      ChartData('30', 0),
      ChartData('31', 0),
      ChartData('32', 0),
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

class ChartData {
  ChartData(this.x, this.y);
 
  late String x;
  late double y;
}