import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bk_gps_monitoring/route.dart';
import 'package:bk_gps_monitoring/utils/ColorConstant.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool first = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!first) {
      first = true;
      _navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Container(
          height: 300,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SpinKitCircle(
                color: AppColors.main_red,
                size: 50,
              )
            ],
          ),
        )
      ),
    );
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.tabbar, (Route<dynamic> route) => false);
    });

  }
}
