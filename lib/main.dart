import 'package:flutter/material.dart';
import 'userScreens/myHomePage.dart';
import 'package:flutter_girlies_store/adminScreens/admin_home.dart';

void main() => runApp(new MyApp());

String indx;



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Girlies',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(indx),
      routes: <String, WidgetBuilder>{
        '/admin_home': (BuildContext context) => new AdminHome(),
      }

    );
  }
}
