// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// class Conference extends StatelessWidget {

//   final AgoraClient _client = AgoraClient(agoraConnectionData: AgoraConnectionData(
//     appId: "32f8bfeb720a45c3b85e6b47523e8930",
//     tempToken: "007eJxTYAhTPOvBE/r30X7O3ZO8Pm0rm5m6wmthytR3GoppLz8uOh+swGBslGaRlJaaZG5kkGhimmycZGGaapZkYm5qZJxqYWls0Pw+MrUhkJHB5bQ2CyMDBIL4LAwlqcUlDAwAtdcgvg==",
//     channelName: "test"
//   ),
//       enabledPermission: [
//         Permission.camera,Permission.microphone
//       ]
//   );

//   Conference({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AgoraVideoViewer(client: _client ,),
//             AgoraVideoButtons(client: _client),
//           ],
//         ),
//       )
//     );
//   }
// }
