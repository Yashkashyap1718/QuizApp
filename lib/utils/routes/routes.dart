import 'package:flutter/material.dart';
import 'package:flutter_quiz/views/Auth/mobile_number.dart';
import 'package:flutter_quiz/views/Auth/register_screen.dart';
import 'package:flutter_quiz/views/auth/otp_screen.dart';
import 'package:flutter_quiz/views/home/home_screen.dart';
import 'package:flutter_quiz/views/results_screen.dart';
import 'package:flutter_quiz/views/splash_screen.dart';
import 'package:flutter_quiz/views/bottom_Bar/tabbar.dart';

const initialRoute = "/";
const mobileRoute = '/mobile_number';
const otpRoute = '/otp_screen';
const registerRoute = '/register_screen';
const bottomBarRoute = '/tabbar';
const homeRoute = "/home_screen";
const resultRoute = '/results_screen';

final routes = {
  initialRoute: (context) => const SplashScreen(),
  mobileRoute: (context) => const MobileScreen(),
  otpRoute: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final verificationId = args['verficationId'];
    final phoneNumber = args['phoneNumber'];

    return OTPScreen(
      verificationId: verificationId,
      phoneNumber: phoneNumber,
    );
  },
  registerRoute: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final phone = args['phone'];
    final uid = args['uid'];

    return RegisterScreen(phone: phone, uid: uid);
  },
  bottomBarRoute: (context) => const TabBarScreen(),
  homeRoute: (context) => HomePage(),
  resultRoute: (context) => const ResultsScreen()
};
