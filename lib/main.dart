import 'package:flutter/material.dart';
import 'package:fluttertube/screens/home.dart';

import 'api.dart';

void main() {
  Api().search('eletro');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTube',
      home: Home(),
    );
  }
}
