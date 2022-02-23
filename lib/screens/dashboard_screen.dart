import 'dart:collection';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // widget.data.forEach((key, value) => {
    //       if (constraintset.contains(key) == false)
    //         {series.add(DrowsyData(time: key, count: int.parse(value)))}
    //     });
    print(widget.id);
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

                  return Text("loading");
                }),
            Divider(
              thickness: 2,
            ),
            // series.length > 0
            //     ? SfCartesianChart(
            //         title: ChartTitle(
            //             text: '${['Name']} \'s  Drowsiness status'),
            //         primaryXAxis: CategoryAxis(
            //             labelIntersectAction:
            //                 AxisLabelIntersectAction.multipleRows,
            //             labelStyle:
            //                 TextStyle(color: Colors.deepOrange, fontSize: 10)),
            //         primaryYAxis:
            //             NumericAxis(minimum: 0, maximum: 10, interval: 1),
            //         series: <LineSeries<DrowsyData, String>>[
            //           LineSeries<DrowsyData, String>(
            //               dataSource: series,
            //               xValueMapper: (DrowsyData data, _) => data.time,
            //               yValueMapper: (DrowsyData data, _) => data.count,
            //               dataLabelSettings:
            //                   DataLabelSettings(isVisible: true)),
            //         ],
            //       )
            //     : Container(
            //         padding: EdgeInsets.only(top: 30),
            //         child: Center(
            //           child: Text(
            //             'Sorry we don\'t have enough data to present it to you.',
            //             style: TextStyle(
            //                 color: Colors.red, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //       ),
          ],
        ),
      ),
    );
  }
}
