// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_quiz/provider/home_provider.dart';
import 'package:flutter_quiz/src/databaseProvider.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/utils/routes/routes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseProvider db = DatabaseProvider();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final HomeProvider provider =
        Provider.of<HomeProvider>(context, listen: false);

    navigat(r) async {
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, r, (route) => false);
    }

    navigateNext() async {
      await db.getUsers().then((user) async {
        if (user.uid != null && user.uid!.isNotEmpty) {
          await db.getUserStatus().then((value) {
            // if (value.userId != null && value.userId!.isNotEmpty) {
            //   provider.updateUser(user, value);
            //   navigat(bottomBarRoute);
            // } else {
            //   navigat(mobileRoute);
            // }

            navigat(bottomBarRoute);
          });
        } else {
          navigat(mobileRoute);
        }
      });
    }

    navigateNext();

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: width * 0.25),
      decoration: const BoxDecoration(color: whiteColor),
      child: Center(
        child: Image.asset(
          'assets/quiz2.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
