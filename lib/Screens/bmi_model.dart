// ignore_for_file: unused_import, file_names, avoid_web_libraries_in_flutter

import 'package:firebase_auth/firebase_auth.dart';

class DataModel {
  String? uid;
  double? bmi;

  DataModel({this.uid, this.bmi});

  // DATA FROM SERVER
  factory DataModel.fromMap(map) {
    return DataModel(
      uid: map['uid'],
      bmi: map['bmi'],
    );
  }

  // SENDING DATA TO SERVER
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'bmi': bmi,
    };
  }
}
