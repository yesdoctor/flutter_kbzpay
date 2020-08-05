import 'package:flutter/material.dart';

import 'package:flutter_kbzpay/flutter_kbzpay.dart';
import 'package:flutter_kbzpay_example/success.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    FlutterKbzpay.onPayStatus().listen((data) {
      print('onPayStatus $data');
      print(data['status']);
      if (data['status'] == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) {
          return Success();
        }));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  FlutterKbzpay.startPay(
                      appId: "",
                      appKey: "",
                      merchantCode: "",
                      prepayId: ""
                  ).then((value) => { print(value) });
                },
                child: Text("Start Pay"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
