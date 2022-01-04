// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(10),
                    color: Colors.deepOrangeAccent.shade100,
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                                child: Text(
                              document['bmi'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                                child: Text(
                              document['time'],
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            )),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
