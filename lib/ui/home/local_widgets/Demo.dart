import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bk_gps_monitoring/ui/home/local_widgets/PowerStrengthChart.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/provider/PowerStrengthProvider.dart';

class Demo extends StatefulWidget {
  Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PowerStrengthProvider()
          ),
        ], child: PowerStrengthChart()
      )
    );
  }
}
