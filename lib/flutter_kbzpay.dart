import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterKbzpay {
  static const MethodChannel _channel = const MethodChannel('flutter_kbzpay');
  static const EventChannel _eventChannel = const EventChannel('flutter_kbzpay/pay_status');
  static Stream<dynamic> _streamPayStatus;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //Payment callback
  //Only return status code 1 || 2 || 3
  // String COMPLETED = 1;
  // String FAIL = 2;
  // String CANCEL = 3;
  static Stream<dynamic> onPayStatus() {
    if (_streamPayStatus == null) {
      _streamPayStatus = _eventChannel.receiveBroadcastStream();
    }
    return _streamPayStatus;
  }

  static Future<String> startPay({
    @required appId,
    @required appKey,
    @required merchantCode,
    @required prepayId,
    urlScheme
  }) async {
    if (prepayId == null ||
        merchantCode == null ||
        appId == null ||
        appKey == null) {
      throw ("parameter error");
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'appId': appId,
      'appKey': appKey,
      'merchantCode': merchantCode,
      'prepayId': prepayId,
      'urlScheme' : urlScheme
    };

    final String result = await _channel.invokeMethod('startPay', params);

    return result;
  }
}
