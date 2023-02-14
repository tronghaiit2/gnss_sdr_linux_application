import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:bk_gps_monitoring/utils/AppColors.dart';

import 'package:bk_gps_monitoring/ui/common_widgets/NotificationDialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SelectSVs(
        onSelectParam: (HashSet<String> param) {
            // do something with param
        },
        selectedItems: [],
      ),
    );
  }
}

class SelectSVs extends StatefulWidget {
  Function(HashSet<String>) onSelectParam;
  List<String> selectedItems;
  SelectSVs({Key? key, required this.onSelectParam, required this.selectedItems}) : super(key: key);

  @override
  State<SelectSVs> createState() => _SelectSVsState();
}

class _SelectSVsState extends State<SelectSVs> {
  List<String> gpsPRNList = [
    "01", "02", "03", "04", "05", "06", "07", "08",
    "09", "10", "11", "12", "13", "14", "15", "16",
    "17", "18", "19", "20", "21", "22", "23", "24",
    "25", "26", "27", "28", "29", "30", "31", "32"
  ];
  int maxSelections = 8;
  bool _init = false;

  HashSet<String> selectedItem = HashSet<String>();

  @override
  void initState() {
    // TODO: implement initState
    for(var item in widget.selectedItems) {
      selectedItem.add(item);
    }
    _init = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        leadingWidth: 150,
        toolbarHeight: 30,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                // Navigator.of(context).pop();
                selectedItem.clear();
                setState(() {});
              },
              icon: Icon(Icons.remove_circle, size: 14,color: AppColors.red,)
            ),
            Text(getSelectedItemCount()),
          ],
        ),
        title: Text("Select GPS Satellite",
          style: TextStyle(fontSize: 14),),
        actions: [
          // Visibility(
          //     visible: selectedItem.isNotEmpty,
          //     child: 
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.orange,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: AppColors.green,
                    splashColor: AppColors.green,
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      widget.onSelectParam(selectedItem);
                    },
                    child: Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.check_rounded, size: 14,),
                      SizedBox(
                        width: 10,
                      ),
                       Text(
                        selectedItem.isNotEmpty ? "Confirm" : "Close",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],),
                  ),
                ),
              ),
            // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.select_all,
          //     color: selectedItem.length == gpsPRNList.length
          //         ? Colors.black
          //         : Colors.white,
          //   ),
          //   onPressed: () {
          //     if (selectedItem.length == gpsPRNList.length) {
          //       selectedItem.clear();
          //     } else {
          //       for (int index = 0; index < gpsPRNList.length; index++) {
          //         selectedItem.add(gpsPRNList[index]);
          //       }
          //     }
          //     setState(() {});
          //   },
          // )
        ],
      ),
      body: Container(
        width: 600,
        alignment: Alignment.center,
        child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        shrinkWrap: true,
        primary: false,
        childAspectRatio: 2.5,
        crossAxisCount: 6,
        children: gpsPRNList.map((String gpsPRN) {
        return Card(
            elevation: 5,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: getListItem(gpsPRN),
            );
          }).toList(),
        ),
      )
    );
  }
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? selectedItem.length.toString() + " item selected"
        : "No item selected";
  }

  void doMultiSelection(String gpsPRN) {
      if (selectedItem.contains(gpsPRN)) {
        selectedItem.remove(gpsPRN);
      } else {
        if(selectedItem.length < 8) {
          selectedItem.add(gpsPRN);
        }
        else {
          showWarningDialog("You can select max 8 Satellite!", context);
        }
      }
      setState(() {});
  }

  InkWell getListItem(String gpsPRN) {
    return InkWell(
        onTap: () {
          doMultiSelection(gpsPRN);
        },
        child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                selectedItem.contains(gpsPRN)
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 16,
                color: Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 20,
                height: 16,
                child: Text(
                  gpsPRN,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        );
  }
}