import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';

import 'package:bk_gps_monitoring/controller/GnssSdrController.dart';

import 'package:bk_gps_monitoring/utils/AppColors.dart';

import 'package:bk_gps_monitoring/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/provider/S4IndexProvider.dart';

import 'package:bk_gps_monitoring/ui/common_widgets/Buttons.dart';
import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';

import 'package:bk_gps_monitoring/ui/home/monitoring_tabs/History.dart';
import 'package:bk_gps_monitoring/ui/home/monitoring_tabs/S4IndexChart.dart';
import 'package:bk_gps_monitoring/ui/home/monitoring_tabs/PowerStrengthChart.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  int pageCount = 3;
  
  late bool _init = false;
  static NewLinuxPlugin _newLinuxPlugin = NewLinuxPlugin();
  static GnssSdrController _gnssSdrController = GnssSdrController(newLinuxPlugin: _newLinuxPlugin);
  late PowerStrengthProvider _powerStrengthProvider;
  late S4IndexProvider _s4indexProvider;

  static const List<String> screenTitles = [
    "History",
    "Power Strength",
    "S4 Index",
  ];

  static List<Widget> screens = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // gnssSdrController = GnssSdrController(newLinuxPlugin: _newLinuxPlugin);
  }

  @override
  void didChangeDependencies() {
    _powerStrengthProvider = Provider.of(context);
    _s4indexProvider = Provider.of(context);
    if(!_init) {
      Future.delayed(const Duration(seconds: 1), () async {
        _powerStrengthProvider.initData();
        _powerStrengthProvider.updateValue({});
        _s4indexProvider.initData();
        _s4indexProvider.updateData({});
        screens = [
          History(gnssSdrController: _gnssSdrController),
          PowerStrengthChart(gnssSdrController: _gnssSdrController, powerStrengthProvider: _powerStrengthProvider),
          S4IndexChart(gnssSdrController: _gnssSdrController, s4indexProvider: _s4indexProvider),
        ];
        _init = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if(!_init) {
      return Container(
        alignment: Alignment.center,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: const SizedBox(
          height: 300,
          width: 300,
          child: SpinKitCircle(
            color: AppColors.main_red,
            size: 50,
          )
        )
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            elevation: 5,
            leadingWidth: 220,
            toolbarHeight: 40,
            backgroundColor: Colors.blueGrey,
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return SafeArea(
                  child: Row(
                    children: [
                      Container(
                        width: 81,
                        padding: EdgeInsets.all(5),
                        child: Image.asset("assets/images/LOGO_SOICT.png"),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: selectedButton("Start", start),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: selectedButton("End", end),
                      ),
                    ],
                  )
                );
              },
            ),
            title: const Text(
              'BK GPS Monitoring',
              textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: selectedButton("Stop", stop),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: selectedButton("Resume", resume),
              ),
              Container(
                width: 100,
                alignment: Alignment.center,
                  child: const Text(
                  '20183730',
                  textAlign: TextAlign.center, maxLines: 1,
                  style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          body: Row(
            children: [
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    tabSelection(),
                    logo(),
                  ],
                )
              ),
              // GPSController(gnssSdrController: _gnssSdrController, loopReceiver: () {
              //   _gnssSdrController.loop = true;
              //   loopReceiver();
              // }),
              tabView()
            ],
          ),
      );
    }
  }

  Widget tabSelection() {
    return Expanded(
      child: ListView.separated(
      itemCount: pageCount,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 5,);
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                _selectedIndex = index;
                pageController.jumpToPage(index);
              });
            },
            child: Container(
              child: SafeArea(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: (_selectedIndex == index) ? 50 : 0,
                      width: 5,
                      color: Colors.blue,

                    ),
                    Expanded(
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 500),
                        height: 50,
                        color: (_selectedIndex == index) ? Colors.blueGrey.withOpacity(0.2) : Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Text(screenTitles[index]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tabView() {
    return Expanded(
      child: PageView(
        controller: pageController,
        children: [
          for(int i = 0; i < pageCount; i++)
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent)
              ),
              child: Center(
                child: screens[i],
              )
            )
        ],
      ),
    );
  }

  Widget logo() {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Image.asset("assets/images/LOGO_HUST.png", width: 50,),
        ),
      ],
    );
  }

  void start() async {
    if(_gnssSdrController.messageQueueAvailable == false) {
      _gnssSdrController.initMessageQueue();
      _gnssSdrController.messageQueueAvailable = true;
    }
    // final dir = await getTemporaryDirectory();
    // Process.run("${dir.path}/assets/tmp/send", []);
    // Process.run("assets/tmp/send", []);
    Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-gnss-sdr_GPS_L1_rtlsdr_realtime.conf"]);
    // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-trees-GNSS-SDR-receiver.conf"]);
    // Process.run("assets/bin/gnss-sdr", ["--config_file=assets/conf/test-c2-GNSS-SDR-receiver.conf"]);
    // _sendData();

    if(_gnssSdrController.isSending) {
      showWarningDialog("GPS SDR is running!", context);
    }
    else if(_gnssSdrController.loop) {
      showWarningDialog("GPS Monitoring is running!", context);
    }
    _gnssSdrController.isSending = true;
    _gnssSdrController.loop = true;
    showLoading(context, "Starting GNSS-SDR");
    await Future.delayed(const Duration(seconds: 5), () async {
      Navigator.of(context).pop();
      _powerStrengthProvider.initData();
      _powerStrengthProvider.updateValue({});
      _s4indexProvider.initData();
      _s4indexProvider.updateData({});
      loopReceiver();
    });
    
  }

  void end() {
    if(!_gnssSdrController.isSending) {
      showWarningDialog("GPS SDR is not running!", context);
    }
    else if(!_gnssSdrController.loop) {
      showWarningDialog("GPS Monitoring is not running!", context);
    }
    _gnssSdrController.isSending = false;
    _gnssSdrController.loop = false;
    _gnssSdrController.endData();
    _gnssSdrController.endMessageQueue();
    _gnssSdrController.messageQueueAvailable = false;
  }

  void stop() {
    if(!_gnssSdrController.isSending) {
      showWarningDialog("GPS SDR is not running!", context);
    }
    else if(!_gnssSdrController.loop) {
      showWarningDialog("GPS Monitoring is not running!", context);
    }
    _gnssSdrController.isSending = false;
    _gnssSdrController.loop = false;
  }

  void resume() {
    if(_gnssSdrController.isSending) {
      showWarningDialog("GPS SDR is running!", context);
    }
    else if(_gnssSdrController.loop) {
      showWarningDialog("GPS Monitoring is running!", context);
    }
    _gnssSdrController.isSending = true;
    _gnssSdrController.loop = true;
    loopReceiver();
  }

  Future<void> loopReceiver() async {
    int errorCount = 0;
    int start, end, dif;
    while(_gnssSdrController.loop) {
      _gnssSdrController.sendData();
      start = DateTime.now().millisecondsSinceEpoch;
      await Future.delayed(const Duration(milliseconds: 975), () async {
        try {
          String? result;
          switch(_selectedIndex) {
            case 0: {
              result = await _gnssSdrController.receiveData();
              break;
            }
            case 1: {
              result = await _gnssSdrController.receiveCN0();
              break;
            }
            case 2: {
              result = await _gnssSdrController.receiveS4();
              break;
            }
          }

          if(result != null) {
            if(result == "end") {
              errorCount++;
              if(errorCount > 4) {
                _gnssSdrController.isSending = false;
                _gnssSdrController.loop = false;
                // ignore: use_build_context_synchronously
                showWarningDialog("Can not receive GPS signal!", context);
              }
            } else {
              if (kDebugMode) {
                print(result);
              }
              errorCount = 0;
              switch(_selectedIndex) {
                case 0: {
                  
                  break;
                }
                case 1: {
                  _powerStrengthProvider.initData();
                  _powerStrengthProvider.updateValue(json.decode(result));
                  break;
                }
                case 2: {
                  _s4indexProvider.updateData(json.decode(result));
                  break;
                }
              }
            }
          } else {
            errorCount++;
            if(errorCount > 4) {
              _gnssSdrController.isSending = false;
              _gnssSdrController.loop = false;
              // ignore: use_build_context_synchronously
              showWarningDialog("Can not receive GPS signal!", context);
            }
          }
        } on Exception catch (e) {
          _gnssSdrController.isSending = false;
          _gnssSdrController.loop = false;
        } 
      });

      end = DateTime.now().millisecondsSinceEpoch;
      dif = end - start;
      if (kDebugMode) {
        print("dif: "+ dif.toString());
      }
    }
  }

}
