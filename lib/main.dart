import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:bk_gps_monitoring/route.dart';
import 'package:bk_gps_monitoring/splash_screen.dart';
import 'package:bk_gps_monitoring/ui/home/Home.dart';

import 'ui/common_widgets/provider/PowerStrengthProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // if (Platform.isLinux) {
  // WindowOptions windowOptions = const WindowOptions(
  //   minimumSize: Size(800, 600),
  //   maximumSize: Size.infinite,
  //   center: false,
  //   backgroundColor: Colors.transparent,
  //   skipTaskbar: true,
  //   titleBarStyle: TitleBarStyle.normal,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });
  // }
  runApp(const GNSS_SDR());
}

class GNSS_SDR extends StatefulWidget {
  const GNSS_SDR({Key? key}) : super(key: key);

  @override
  State<GNSS_SDR> createState() => _GNSS_SDRState();
}

class _GNSS_SDRState extends State<GNSS_SDR> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('GNSS SDR Application'),
      //   ),
      //   body: 
      //   Center(
      //     child: Home()
      //   )
      // ),
      routes: Routes.routes,
      home: SplashScreen()
    );
  }
}
