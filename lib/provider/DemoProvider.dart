import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';

class DemoProvider extends ChangeNotifier{
  late List<List<ChartDataDemo>> data;
  late List<String> gpsPRNSelectedList;
  late int itemsSelected = 1;

  void initData() {
    DateTime dateTime = DateTime.now();
    data = [[ChartDataDemo(dateTime, 0)], 
    [], [], [], [], [], [], [], []];  
    // notifyListeners();
  }

  void updateValue(Map<String, dynamic> dataList) {
    DateTime dateTime = DateTime.now();
    while(data[0].length > 60) {
      for(int i = 0; i < itemsSelected; i++){
        data[i].removeAt(0);
      }
    }
    
    for(int i = 1; i < itemsSelected; i++){
      if(dataList[gpsPRNSelectedList[i-1]] == null || dataList[gpsPRNSelectedList[i-1]] < 0) {
        data[i].add(ChartDataDemo(dateTime, 0));
      } else {
        data[i].add(ChartDataDemo(dateTime, dataList[gpsPRNSelectedList[i-1]]));
      }
    }
    if(data[1].length > 1) {
      data[0].add(ChartDataDemo(dateTime, 0));
    }
    notifyListeners();
  }
}

