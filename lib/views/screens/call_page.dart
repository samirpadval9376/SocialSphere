import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  final String callId;
  final String userId;
  final String userName;
  const CallPage({
    super.key,
    required this.callId,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 547975195, // your AppID,
      appSign:
          'a85fd3fea7f8d0ad300698a236873a271518347eb057fad1492a6cbf92d3ee3e',
      userID: userId,
      userName: userName,
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
