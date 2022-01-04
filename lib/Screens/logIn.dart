// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors, duplicate_ignore, unnecessary_new, prefer_const_declarations

import 'package:bmi/Screens/home.dart';
import 'package:bmi/Screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> Function() sharedPreferences =
    SharedPreferences.getInstance;

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      // ignore: prefer_const_constructors
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username cannot be empty";
                        } else if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Password cannot be empty";
                        } else if (!regex.hasMatch(value)) {
                          return "Please enter valid password (Minimum 6 characters)";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Login'),
                        onPressed: () {
                          SignInFunction(context, emailController.text,
                              passwordController.text);
                        },
                      )),
                  Container(
                      child: Row(
                    children: <Widget>[
                      Text('Does not have account?'),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ))
                ],
              ),
            )));
  }

  // moveToHome(BuildContext context) {
  //   if (_formKey.currentState!.validate()) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => HomeScreen()));
  //   }
  // }

  void SignInFunction(
      BuildContext context, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      print("sign in pressed");
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                sharedPref(),
                Fluttertoast.showToast(msg: "Login Successfully"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  sharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", emailController.text);
  }
}
