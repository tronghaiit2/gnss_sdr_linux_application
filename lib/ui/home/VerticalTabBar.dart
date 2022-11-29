import 'package:flutter/material.dart';
import 'package:bk_gps_monitoring/provider/PowerStrengthProvider.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/Demo.dart';
import 'package:bk_gps_monitoring/ui/home/local_widgets/PowerStrengthChart.dart';
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

  static const List<String> screenTitles = [
    "Power Strength",
    "Files",
    "Real Time",
  ];

  static List<Widget> screens = [
    PowerStrengthChart(),
    Container(),
    Container()
  ];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Row(
          children: [
            SizedBox(width: 150,
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
