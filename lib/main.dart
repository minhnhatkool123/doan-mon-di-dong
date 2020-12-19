import 'package:flutter/material.dart';
import 'package:doannote/screen/container_main.dart';
import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.g,
      // ),
      theme: ThemeData(
        textTheme: TextTheme(
          headline5: TextStyle(
            fontFamily: 'Sans',
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'App Note',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        body: SafeArea(
          child: ContaninerMain(),
        ),
      ),
    );
  }
}
