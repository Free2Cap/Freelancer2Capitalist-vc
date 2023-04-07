import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'complete_profile.dart';

class VerifyEmail extends StatefulWidget {
  final UserModel newUser;
  final User credential;
  const VerifyEmail(
      {super.key, required this.newUser, required this.credential});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  @override
  void initState() {
    user = auth.currentUser;
    user?.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple, // Add a purple color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon( // Add an email icon logo
              Icons.email,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(height: 20.0), // Add a space between the icon and the text
            Text(
              'An Email has been sent to ${user?.email} please verify.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0, // Increase the text size
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user?.reload();
    if (user!.emailVerified) {
      timer?.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CompleteProfile(
                userModel: widget.newUser,
                firebaseUser: widget.credential,
              )));
    }
  }
}
