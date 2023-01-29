import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/models/ChartDataDemo.dart';

class S4IndexProvider extends ChangeNotifier{
  late List<ChartDataDemo> data_0;
  late List<List<ChartDataDemo>> data, channelI, channelQ;
  late List<String> gpsPRNSelectedList;
  late int itemsSelected = 0;

  void initData() {
    DateTime dateTime = DateTime.now();
    data_0 = [ChartDataDemo(dateTime, 0)];
    data = [[], [], [], [], [], [], [], []];  
    channelI = [[], [], [], [], [], [], [], []];  
    channelQ = [[], [], [], [], [], [], [], []];  
    // notifyListeners();
  }

  void updateData(Map<String, dynamic> dataList) {
    DateTime dateTime = DateTime.now();
    while(data_0.length > 60) {
      data_0.removeAt(0);
      for(int i = 0; i < itemsSelected; i++){
        data[i].removeAt(0);
      }
    }
    
    for(int i = 0; i < itemsSelected; i++){
      String prn = int.parse(gpsPRNSelectedList[i]).toString();

      if(dataList[prn] == null || dataList[prn] < 0) {
        data[i].add(ChartDataDemo(dateTime, 0));
      } else {
        data[i].add(ChartDataDemo(dateTime, dataList[prn]));
      }
    }

    data_0.add(ChartDataDemo(dateTime, 0));
    notifyListeners();
  }

  void updateValue(Map<String, dynamic> dataListI, Map<String, dynamic> dataListQ) {
    DateTime dateTime = DateTime.now();
    while(data_0.length > 60) {
      data_0.removeAt(0);
      for(int i = 0; i < itemsSelected; i++){
        channelI[i].removeAt(0);
        channelQ[i].removeAt(0);
      }
    }
    
    for(int i = 0; i < itemsSelected; i++){
      String prn = int.parse(gpsPRNSelectedList[i]).toString();

      if(dataListI[prn] == null || dataListI[prn] < 0) {
        channelI[i].add(ChartDataDemo(dateTime, 0));
      } else {
        channelI[i].add(ChartDataDemo(dateTime, dataListI[prn]));
      }

      if(dataListQ[prn] == null || dataListQ[prn] < 0) {
        channelQ[i].add(ChartDataDemo(dateTime, 0));
      } else {
        channelQ[i].add(ChartDataDemo(dateTime, dataListQ[prn]));
      }
    }

    data_0.add(ChartDataDemo(dateTime, 0));
    notifyListeners();
  }
}

