import 'package:drowsy_dashboard/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F8FE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/logo-png.png"),
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Text(
                'Closensor',
                style: TextStyle(letterSpacing: 2, color: Color(0xff3D4785)),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen(type: "Owner")));
                  },
                  child: Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffEBEFFA),
                              blurRadius: 10,
                              spreadRadius: 3,
                              offset: Offset(3, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/owner.png",
                            height: 40,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "OWNER",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3D4785)),
                          )
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignUpScreen(type: "Driver")));
                  },
                  child: Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffEBEFFA),
                              blurRadius: 10,
                              spreadRadius: 3,
                              offset: Offset(3, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/driver.png",
                            height: 40,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "DRIVER",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3D4785)),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
