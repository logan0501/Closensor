import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drowsy_dashboard/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardScreen extends StatefulWidget {
  String id;
  DashBoardScreen({required this.id});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
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
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "DashBoard",
          style:
              TextStyle(color: Color(0xff3E4685), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 35,
              child: Icon(
                Icons.account_circle,
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${data['Name']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${data['Email']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${data['Mobile']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${data['Vehicle Type']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "${data['Vehicle Num']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    value: chosenMonth,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),

                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Month",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
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
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    value: chosenyear,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),

                    items: years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Year",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
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
                return SfCartesianChart(
                  title: ChartTitle(text: 'Drowsiness Plot'),
                  primaryXAxis: CategoryAxis(
                      labelIntersectAction:
                          AxisLabelIntersectAction.multipleRows,
                      labelStyle:
                          TextStyle(color: Colors.deepOrange, fontSize: 10)),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 10, interval: 1),
                  series: <LineSeries>[
                    LineSeries<TimeStamp, String>(
                        dataSource: timestamplist,
                        xValueMapper: (TimeStamp timestamp, _) {
                          if (choice == "YEAR") {
                            String date = getYear(timestamp.time.toString());
                            if (chosenyear == date) {
                              print(date);
                              return months[int.parse(
                                  getMonth(timestamp.time.toString()))];
                            }
                          } else {
                            String date = getMonth(timestamp.time.toString());
                            if (chosenMonth == "ALL")
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
