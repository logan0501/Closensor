import 'dart:collection';
import 'dart:io';
import 'package:path/path.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drowsy_dashboard/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class DashBoardScreen extends StatefulWidget {
  String id, type;
  DashBoardScreen({required this.id, required this.type});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<TimeStamp> timeStamps = [];
  HashSet<String> constraintset =
      HashSet.from({"Name", "Vehicle Num", 'Vehicle Type', 'id'});
  static List<String> years = ['2022', '2023'];
  static List<String> months = [
    'ALL',
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];
  String chosenyear = years.first;
  String? chosenMonth;
  String choice = "YEAR";
  Map<String, String> mytimestamps = {};

  void saveExcel() async {}

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> timestamps = FirebaseFirestore.instance
        .collection('drivers')
        .doc(widget.id)
        .collection('timestamps')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => widget.type == "owner"
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xff555B95),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LandingScreen()));
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color(0xff3E4685),
                  )),
        ),
        title: Text(
          "Profile",
          style:
              TextStyle(color: Color(0xff3E4685), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              // dynamic values support provided;

              saveExcel();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image(
                width: 40,
                image: AssetImage("assets/excel.png"),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Color(0xff3D4785),
              radius: 35,
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('drivers')
                  .doc(widget.id)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  print(data);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Name : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E4685),
                              ),
                            ),
                            TextSpan(
                              text: "${data['Name']}",
                              style: TextStyle(
                                  color: Color(0xff262626),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Email : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E4685),
                              ),
                            ),
                            TextSpan(
                              text: "${data['Email']}",
                              style: TextStyle(
                                  color: Color(0xff262626),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Mobile : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E4685),
                              ),
                            ),
                            TextSpan(
                              text: "${data['Mobile']}",
                              style: TextStyle(
                                  color: Color(0xff262626),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Vehicle Type : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E4685),
                              ),
                            ),
                            TextSpan(
                              text: "${data['Vehicle Type']}",
                              style: TextStyle(
                                  color: Color(0xff262626),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "Vehicle Num : ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E4685),
                              ),
                            ),
                            TextSpan(
                              text: "${data['Vehicle Num']}",
                              style: TextStyle(
                                  color: Color(0xff262626),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      )
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              thickness: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Color(0xffE5E8F9),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    value: chosenMonth,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),

                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Color(0xff3E4685),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Month",
                      style: TextStyle(
                          color: Color(0xff3E4685),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      setState(() {
                        chosenMonth = value!;
                        choice = "MONTH";
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Color(0xffE5E8F9),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    value: chosenyear,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),

                    items: years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                color: Color(0xff3E4685),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    hint: Text(
                      "Year",
                      style: TextStyle(
                          color: Color(0xff3E4685),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    onChanged: (value) {
                      setState(() {
                        chosenyear = value!;
                        choice = "YEAR";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: timestamps,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                List<TimeStamp> timestamplist = [];
                snapshot.data!.docs.forEach((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  mytimestamps[data['time']] = data['value'].toString();

                  timestamplist
                      .add(TimeStamp(time: data['time'], value: data['value']));
                });
                print(mytimestamps.length);
                timestamplist.sort((a, b) => a.time.compareTo(b.time));

                timeStamps = timestamplist;

                return SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  title: ChartTitle(
                      text: 'Drowsiness Plot',
                      textStyle: TextStyle(
                          color: Color(0xff3E4685),
                          fontWeight: FontWeight.bold)),
                  primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                          text: 'Timestamp',
                          textStyle: TextStyle(
                              color: Color(0xff727272), fontSize: 10)),
                      labelIntersectAction:
                          AxisLabelIntersectAction.multipleRows,
                      labelStyle:
                          TextStyle(color: Color(0xff020202), fontSize: 10)),
                  primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 10,
                      interval: 1,
                      title: AxisTitle(
                          text: 'Count',
                          textStyle: TextStyle(
                              color: Color(0xff727272), fontSize: 10))),
                  series: <ChartSeries>[
                    ColumnSeries<TimeStamp, String>(
                        color: Color(0xff3E4685).withOpacity(0.8),
                        enableTooltip: true,
                        dataSource: timestamplist,
                        xValueMapper: (TimeStamp timestamp, _) {
                          if (choice == "YEAR") {
                            Map<String, int> umap = {};
                            String date = getYear(timestamp.time.toString());
                            if (chosenyear == date) {
                              print(date);
                              return months[int.parse(
                                  getMonth(timestamp.time.toString()))];
                            }
                          } else {
                            String date = getMonth(timestamp.time.toString());
                            print(getMonth(timestamp.time.toString()));
                            if (chosenMonth == "ALL" &&
                                getYear(timestamp.time.toString()) ==
                                    chosenyear)
                              return getDate(timestamp.time.toString());

                            if (int.parse(date) ==
                                months.indexOf(chosenMonth!)) {
                              return getDate(timestamp.time.toString());
                            }
                          }
                        },
                        yValueMapper: (TimeStamp timestamp, _) =>
                            int.parse(timestamp.value),
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                  ],
                );
              })
        ],
      ),
    );
  }
}

class TimeStamp {
  final String time;
  final String value;
  TimeStamp({required this.time, required this.value});
}

String getDate(String time) {
  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(time);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd-MM-yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getMonth(String time) {
  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(time);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MM');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String getYear(String time) {
  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(time);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
