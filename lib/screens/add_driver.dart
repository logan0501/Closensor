import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drowsy_dashboard/components/custom_snackbar.dart';
import 'package:drowsy_dashboard/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController vehicleNumController = TextEditingController();
  String? _chosenValue;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
      ),
      body: SingleChildScrollView(
        child: _isLoading == false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 40,
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 40,
                            ),
                            onPressed: () {
                              print('hello');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: mobileController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: DropdownButton<String>(
                          value: _chosenValue,
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),

                          items: <String>[
                            'Car',
                            'Bus',
                            'Lorry',
                            'Van',
                            'Mini-Van',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text(
                            "Vehicle Type",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _chosenValue = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: vehicleNumController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle Number',
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final name = nameController.text;
                            final email = emailController.text;
                            final mobile = mobileController.text;
                            final vehicleType = _chosenValue;
                            final vehicleNum = vehicleNumController.text;
                            if (name.isNotEmpty &&
                                email.isNotEmpty &&
                                mobile.isNotEmpty &&
                                vehicleNum.isNotEmpty &&
                                vehicleType.toString().isNotEmpty) {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: email,
                                  password: mobile,
                                );
                                String id = userCredential.user!.uid;
                                Map<String, String> data = {
                                  "Name": name,
                                  "Email": email,
                                  "Mobile": mobile,
                                  "Vehicle Type": vehicleType.toString(),
                                  "Vehicle Num": vehicleNum,
                                  "id": id,
                                };
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(id)
                                    .set({
                                  "Name": name,
                                  "Type": "Driver",
                                  "id": id,
                                });
                                FirebaseFirestore.instance
                                    .collection('drivers')
                                    .doc(id)
                                    .set(data);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar('Driver added sucessfully',
                                        Colors.green));
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(
                                          'The password provided is too weak.',
                                          Colors.red));
                                } else if (e.code == 'email-already-in-use') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      customSnackBar(
                                          'The account already exists for that email.',
                                          Colors.red));
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    customSnackBar(e.toString(), Colors.red));
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackBar(
                                      'Please provide us valid credentials',
                                      Colors.red));
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Add Driver'),
                          )))
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
