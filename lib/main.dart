import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen_a.dart';
import 'screen_b.dart';
import 'screen_c.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('nfc_channel');

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onNewNfcIntent') {
        final nfcData = call.arguments as String;
        _handleNfcData(nfcData);
      }
    });
  }

  void _handleNfcData(String data) {
    if (data.contains("A")) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenA()));
    } else if (data.contains("B")) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenB()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenC()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('NFC 태그를 스캔하세요')),
    );
  }
}
