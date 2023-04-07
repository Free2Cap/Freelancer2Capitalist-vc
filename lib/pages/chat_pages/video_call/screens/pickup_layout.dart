import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:freelancer2capitalist/pages/chat_pages/video_call/call_methods.dart';
import 'package:freelancer2capitalist/pages/chat_pages/video_call/screens/pickup_screen.dart';

import '../../../../models/callModel.dart';
import '../../../../models/user_model.dart';

class PickupLayout extends StatelessWidget {
  PickupLayout({super.key, required this.scaffold});
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return (user != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final Map<String, dynamic>? callData =
                    snapshot.data?.data() as Map<String, dynamic>?;
                if (callData != null) {
                  final Call call = Call.fromMap(callData);
                  // do something with the call object
                  if (!call.hasDialled!) {
                    return PickupScreen(call: call);
                  }
                  return scaffold;
                }

                return scaffold;
              }
              return scaffold;
            },
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
