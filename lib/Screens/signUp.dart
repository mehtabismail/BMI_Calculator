// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors, duplicate_ignore, unnecessary_new

import 'package:bmi/Screens/home.dart';
import 'package:bmi/Screens/signUp_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController secondNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

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
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      // ignore: prefer_const_constructors
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                      onSaved: (value) {
                        firstNameController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First Name cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: secondNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e-mail address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email cannot be empty";
                        } else if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      onSaved: (value) {
                        confirmPasswordController.text = value!;
                      },
                      validator: (value) {
                        if (confirmPasswordController.text !=
                            passwordController.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
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
                        child: Text('Sign Up'),
                        onPressed: () {
                          signUpFunction(
                              emailController.text, passwordController.text);
                        },
                      )),
                ],
              ),
            )));
  }

  void signUpFunction(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFireStore()})
          .catchError((e) => {Fluttertoast.showToast(msg: e!.message)});
    }
  }

  void postDetailsToFireStore() async {
    // CALLING OUR FIRESTORE
    // CALLING OUR USERMODEL
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    // WRITTING ALL THE VALUES
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameController.text;
    userModel.secondName = secondNameController.text;

    // SENDING THESE VALUES TO FIRESTORE
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    // SHOWING TOAST MESSAGE
    Fluttertoast.showToast(msg: "Account Created Successfully");

    // NAVIGATE TO HOME SCREEN
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
