import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanker_app/src/auth/views/phone_auth_screen.dart';
import 'package:tanker_app/src/booking/views/booking_screen.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        log('$snapshot');
        if (snapshot.hasData) {
          return const BookingScreen();
        }
        return const PhoneAuthScreen();
      },
    );
  }
}
