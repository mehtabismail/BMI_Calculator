import 'package:bmi/Screens/home.dart';
import 'package:bmi/Screens/logIn.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String finalEmail = '';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    getValidationData().whenComplete(() async => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      (finalEmail == '' ? LogIn() : HomeScreen())))
        });
    super.initState();
  }

  Future getValidationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail!;
    });
    print(finalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
