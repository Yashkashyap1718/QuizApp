import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz/models/question_model.dart';
import 'package:flutter_quiz/src/firebaseClient.dart';
import 'package:flutter_quiz/utils/components/question.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/utils/routes/routes.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  FirebaseClient firebaseClient = FirebaseClient();
  List<Question> questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey2Color,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Quiz',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 5,
          backgroundColor: whiteColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AboutUs()));
                  },
                  child: SizedBox(
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, bottomBarRoute);
                },
                child: const SizedBox(
                    height: 35,
                    width: 35,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: firebaseClient.getData("Quiz/Computer/2/", 0, context),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: baseColor,
                  ),
                );
              }

              List<dynamic> extractedData =
                  snapshot.data.docs.map((DocumentSnapshot value) {
                return value.data();
              }).toList();

              if (extractedData.isNotEmpty) {
                questions = extractedData
                    .where((data) => data != null) // Filter out null data
                    .cast<Map<String, dynamic>>() // Cast to the expected type
                    .map((e) => Question.fromJson(e))
                    .toList();
                questions.shuffle();
              }

              return Questions(
                questions: questions,
                value: 1,
              );
            }));
  }
}
