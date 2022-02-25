import 'package:drowsy_dashboard/screens/add_driver.dart';
import 'package:drowsy_dashboard/screens/dashboard_screen.dart';
import 'package:drowsy_dashboard/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final Stream<QuerySnapshot> _driverstream =
      FirebaseFirestore.instance.collection('drivers').snapshots();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xffF1F5FE),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          'DashBoard',
          style:
              TextStyle(color: Color(0xff525B92), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xffF1F5FE),
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Color(0xff333333),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Color(0xff333333),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LandingScreen()));
            },
          )
        ],
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: StreamBuilder<QuerySnapshot>(
        stream: _driverstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () => {
                  print(document.id),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DashBoardScreen(id: document.id.toString())))
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 10))
                    ]),
                    child: Card(
                      color: Color(0xffFFFFFF),
                      elevation: 0,
                      child: ListTile(
                        leading: Icon(
                          Icons.account_box_rounded,
                          size: 45,
                          color: Color(0xff555C93).withOpacity(0.5),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Name : ${data["Name"]}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff020202)),
                          ),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vehicle Type : ${data["Vehicle Type"]}",
                                  style: TextStyle(color: Color(0xff717171)),
                                ),
                                Text("Vehicle Num : ${data["Vehicle Num"]}"),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      )),
// This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff3E4685),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xff555C93),
                    radius: 35,
                    child: Icon(
                      Icons.account_circle,
                      size: 70,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'UserName',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'logan@gmail.com',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Add driver',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff404585)),
              ),
              leading: Icon(
                Icons.add_reaction,
                color: Color(0xff9B9B9B),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddDriverScreen()));
              },
            ),
            ListTile(
              title: const Text(
                'Drivers list',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff404585)),
              ),
              leading: Icon(
                Icons.format_list_bulleted,
                color: Color(0xff9B9B9B),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text(
                'Edit driver',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff404585)),
              ),
              leading: Icon(
                Icons.edit,
                color: Color(0xff9B9B9B),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
              child: Divider(
                thickness: 2,
              ),
            ),
            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff4E4E4E)),
              ),
              leading: Icon(
                Icons.logout,
                color: Color(0xff9B9B9B),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LandingScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
