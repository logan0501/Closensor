import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drowsy_dashboard/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardScreen extends StatefulWidget {
  Map<String, dynamic> data;
  DashBoardScreen({required this.data});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  HashSet<String> constraintset =
      HashSet.from({"Name", "Vehicle Num", 'Vehicle Type', 'id'});
  List<DrowsyData> series = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.data.forEach((key, value) => {
          if (constraintset.contains(key) == false)
            {series.add(DrowsyData(time: key, count: int.parse(value)))}
        });
    print(series);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DashBoard Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Name : ${widget.data["Name"]}"),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vehicle Type : ${widget.data["Vehicle Type"]}"),
                        Text("Vehicle Num : ${widget.data["Vehicle Num"]}"),
                      ]),
                ),
              ),
            ),
            series.length > 0
                ? SfCartesianChart(
                    title: ChartTitle(
                        text: '${widget.data['Name']} \'s  Drowsiness status'),
                    primaryXAxis: CategoryAxis(
                        labelIntersectAction:
                            AxisLabelIntersectAction.multipleRows,
                        labelStyle:
                            TextStyle(color: Colors.deepOrange, fontSize: 10)),
                    primaryYAxis:
                        NumericAxis(minimum: 0, maximum: 10, interval: 1),
                    series: <LineSeries<DrowsyData, String>>[
                      LineSeries<DrowsyData, String>(
                          dataSource: series,
                          xValueMapper: (DrowsyData data, _) => data.time,
                          yValueMapper: (DrowsyData data, _) => data.count,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: true)),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: Text(
                        'Sorry we don\'t have enough data to present it to you.',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class DrowsyData {
  final String time;
  final int count;
  DrowsyData({required this.time, required this.count});
}
