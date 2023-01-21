import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:bk_gps_monitoring/route.dart';
import 'package:bk_gps_monitoring/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // ignore: prefer_const_constructors
  WindowOptions windowOptions = WindowOptions(
    minimumSize: const Size(720, 360),
    maximumSize: Size.infinite,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
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
