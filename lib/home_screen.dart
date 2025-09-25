import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'screen_a.dart';
import 'screen_b.dart';
import 'screen_c.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _startNfc();
  }

  void _startNfc() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      debugPrint('NFC 사용 불가');
      return;
    }

    // 앱 실행 중일 때 NFC 태그 스캔 시작
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef == null || ndef.cachedMessage == null) return;

        final records = ndef.cachedMessage!.records;
        if (records.isNotEmpty) {
          // NFC에 기록된 텍스트
          String payload = String.fromCharCodes(records.first.payload);
          // NDEF payload는 보통 앞에 언어코드 byte가 있어서 잘라야함
          if (payload.isNotEmpty) {
            payload = payload.substring(3); // en 앞의 3byte 제거
          }

          // 값에 따라 화면 분기
          if (payload == 'A') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenA()));
          } else if (payload == 'B') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenB()));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ScreenC()));
          }
        }
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('NFC 태그를 스캔하세요')),
    );
  }
}
