// ignore_for_file: use_key_in_widget_constructors, file_names, avoid_init_to_null, prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, await_only_futures

import 'package:intl/intl.dart';
import 'package:bmi/Screens/bmi_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
dynamic currentTime = DateFormat.jm().format(DateTime.now());

class CalculateBMI extends StatefulWidget {
  @override
  _CalculateBMIState createState() => _CalculateBMIState();
}

class _CalculateBMIState extends State<CalculateBMI> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double result = 0;
  String variable = '';

  void calculateBMI_function() async {
    double height = double.parse(_heightController.text) / 100;
    double weight = double.parse(_weightController.text);

    double heightSquare = await height * height;
    double bmi = await weight / heightSquare;
    result = await bmi;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'height in cm',
                    icon: Icon(Icons.trending_up),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'weight in kg',
                    icon: Icon(Icons.line_weight),
                  ),
                ),
                SizedBox(height: 15),
                RaisedButton(
                  color: Colors.pinkAccent,
                  child: Text(
                    "Calculate BMI",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    calculateBMI_function();
                    variable = "yess";
                  },
                ),
                SizedBox(height: 30),
                Text(
                  result == 0
                      ? "Enter Value"
                      : "Your BMI is : ${result.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    print("hello");
                    await FirebaseFirestore.instance.collection('data').add({
                      'bmi': "BMI : ${result.toStringAsFixed(4).toString()}",
                      'time': "Date & Time : ${DateTime.now().toString()}",
                    });
                    // SHOWING TOAST MESSAGE
                    Fluttertoast.showToast(msg: "Data Uploaded Successfully");
                  },
                  child: Text(
                    variable == '' ? "" : "Save in History? ",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.pinkAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  final _auth = FirebaseAuth.instance;
  void postDetailsToFireStore() async {
    // CALLING OUR FIRESTORE
    // CALLING OUR USERMODEL
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    DataModel userModel = DataModel();

    // WRITTING ALL THE VALUES
    userModel.bmi = result;
    userModel.uid = user!.uid;

    // SENDING THESE VALUES TO FIRESTORE
    await firebaseFirestore
        .collection("data")
        .doc(user.uid)
        .update(userModel.toMap());
    // SHOWING TOAST MESSAGE
    Fluttertoast.showToast(msg: "Data Uploaded Successfully");
  }
}
