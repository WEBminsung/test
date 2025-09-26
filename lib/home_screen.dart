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
          // NFC에 기록된 텍스트 (payload[0]에는 언어코드가 들어있을 수 있으니 substring)
          String payload = String.fromCharCodes(records.first.payload);
          // NDEF payload는 첫 바이트가 언어 코드 길이를 나타내므로 건너뛰기
          int langCodeLen = records.first.payload[0];
          String text = payload.substring(1 + langCodeLen);

          debugPrint('읽은 값: $text');

          // 값에 따라 분기
          if (text == 'A') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ScreenA()));
          } else if (text == 'B') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ScreenB()));
          } else if (text == 'C') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ScreenC()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('알 수 없는 태그: $text')),
            );
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
      appBar: AppBar(title: Text('NFC 홈')),
      body: Center(child: Text('NFC 태그를 스캔하세요')),
    );
  }
}
