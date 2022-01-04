// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:bmi/Screens/calculateBMI.dart';
import 'package:bmi/Screens/history.dart';
import 'package:bmi/Screens/logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  // ignore: prefer_const_constructors
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalculateBMI()));
                  },
                  child: Text("Calculate BMI", style: TextStyle(fontSize: 18)),
                )),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Center(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  // ignore: prefer_const_constructors
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => History()));
                  },
                  child: Text("Check History", style: TextStyle(fontSize: 18)),
                )),
              ),
              SizedBox(
                height: 100,
              ),
              ActionChip(
                  backgroundColor: Colors.grey,
                  label: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      "Log Out",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    logOut(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('email');
    Fluttertoast.showToast(msg: "LogOut Successfully");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LogIn()));
  }
}
