import 'package:bk_gps_monitoring/models/GnssSdrController.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/Settings.dart';
import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/DemoChart.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/PowerStrengthChart.dart';
import 'package:new_linux_plugin/new_linux_plugin.dart';
import 'package:provider/provider.dart';

class VerticalTabBar extends StatefulWidget {
  const VerticalTabBar({Key? key}) : super(key: key);

  @override
  State<VerticalTabBar> createState() => _VerticalTabBarState();
}

class _VerticalTabBarState extends State<VerticalTabBar> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  int pageCount = 3;

  static NewLinuxPlugin _newLinuxPlugin = NewLinuxPlugin();
  static GnssSdrController _gnssSdrController = GnssSdrController(newLinuxPlugin: _newLinuxPlugin);

  static const List<String> screenTitles = [
    "Settings",
    "Power Strength",
    "Real Time",
  ];

  static List<Widget> screens = [
    Settings(gnssSdrController: _gnssSdrController),
    PowerStrengthChart(gnssSdrController: _gnssSdrController),
    DemoChart(gnssSdrController: _gnssSdrController),
  ];

  @override
  void initState() {
    // TODO: implement initState
    // gnssSdrController = GnssSdrController(newLinuxPlugin: _newLinuxPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Expanded(
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
                  ),
                  SafeArea(
                    child: Container(
                      height: 40,
                      child: const Text(
                        'BK GPS',
                        textAlign: TextAlign.center, maxLines: 1,
                        style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  SafeArea(
                    child: Container(
                      height: 30,
                      child: const Text(
                        'Monitoring',
                        textAlign: TextAlign.center, maxLines: 1,
                        style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  SizedBox(height: 30,),
                  SafeArea(
                    child: Container(
                      child: Image.asset("assets/images/LOGO_HUST.png", width: 100,),
                    )
                  ),
                  SizedBox(height: 20,),
                  SafeArea(
                    child: Container(
                      child: Image.asset("assets/images/LOGO_SOICT.png", width: 100,),
                    )
                  ),
                  SizedBox(height: 20,),
                ],
              )
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  for(int i = 0; i < pageCount; i++)
                    Container(
                      color: Colors.blueGrey,
                      child: Center(
                        child: screens[i],
                      )
                    )
                ],
              ),
            )
          ],
        )
    );
  }
}
