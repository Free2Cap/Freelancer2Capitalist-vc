// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:agora_uikit/agora_uikit.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   final AgoraClient _client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: 'e48dfe62bf1444e39d65a3b4bdbb90c7',
//       channelName: 'video',
//       tempToken:
//           '007eJxTYHjgtaX70kPjv33mr76L+Dc/32J60jDqoJZY1wMWpZiNs+4pMKSaWKSkpZoZJaUZmpiYpBpbppiZJhonmSSlJCVZGiSbL5TSTmkIZGRQamxkZWSAQBCflaEsMyU1n4EBAPknIN4=',
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//   }

//   Future<void> _initAgora() async {
//     await _client.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: const Text('video Call'),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: _client,
//                 layoutType: Layout.floating,
//                 showNumberOfUsers: true,
//               ),
//               AgoraVideoButtons(
//                 client: _client,
//                 enabledButtons: const [
//                   BuiltInButtons.toggleCamera,
//                   BuiltInButtons.callEnd,
//                   BuiltInButtons.toggleMic,
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
