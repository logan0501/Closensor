import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drowsy_dashboard/components/custom_snackbar.dart';
import 'package:drowsy_dashboard/screens/dashboard_screen.dart';
import 'package:drowsy_dashboard/screens/home_screen.dart';
import 'package:drowsy_dashboard/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.type}) : super(key: key);
  final String type;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF3F8FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffF3F8FE),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff3C4485),
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LandingScreen()));
          },
        ),
      ),
      body: _isLoading == false
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 10, bottom: 5, left: 10),
                      child: Text(
                        widget.type,
                        style: TextStyle(
                            color: Color(0xff3C4485),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, bottom: 20),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20, letterSpacing: 2),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hoverColor: Color(0xff3E4685),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff3E4685), width: 1.5)),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xff3E4685))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hoverColor: Color(0xff3E4685),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff3E4685), width: 1.5)),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Color(0xff3E4685))),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Color(0xff696969)),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff3E4685)),
                        child: const Text('Login'),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: nameController.text,
                                    password: passwordController.text);
                            String id = await userCredential.user!.uid;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(id)
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                Map<String, dynamic> data = documentSnapshot
                                    .data() as Map<String, dynamic>;
                                if (data['Type'] == widget.type) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(
                                          'User Authenticated sucessfully',
                                          Colors.green));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (widget.type == "Owner") {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyHomePage()));
                                  } else if (widget.type == "Driver") {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen(
                                                    id: id, type: "driver")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(
                                          'User does not exist', Colors.red));
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar(
                                        'User does not exist', Colors.red));
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            });
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar(
                                    'Please provide us the valid credentials',
                                    Colors.red));
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Does not have account?',
                        style: TextStyle(color: Color(0xff757575)),
                      ),
                      TextButton(
                        child: const Text(
                          'Contact Admin',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff3E4685),
                          ),
                        ),
                        onPressed: () {
                          //signup screen
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
