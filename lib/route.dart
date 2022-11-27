/*This file contains all the routes for this application.*/
import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/ui/home/Home.dart';
import 'package:bk_gps_monitoring/ui/home/VerticalTabBar.dart';
import 'package:provider/provider.dart';

class Routes {
  Routes._();

  //static variables
  static const String tabbar = "/tabbar";
  static const String home = "/home";

  // static const String history = "/history";

  static final routes = <String, WidgetBuilder>{

    home: (BuildContext context) => Home(),
    tabbar: (BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PowerStrengthProvider()
          ),
        ], child: VerticalTabBar(),
    )
    // history: (BuildContext context) => History(),
  };
}
