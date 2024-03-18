// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quiz/models/question_model.dart';
import 'package:flutter_quiz/provider/home_provider.dart';
import 'package:flutter_quiz/src/firebaseClient.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/utils/routes/routes.dart';
import 'package:flutter_quiz/views/results_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Questions extends StatefulWidget with WidgetsBindingObserver {
  final List<Question> questions;
  final int value;
  const Questions({super.key, required this.questions, required this.value});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final PageController _pageController = PageController(initialPage: 0);
  FirebaseClient firebaseClient = FirebaseClient();
  late List<Question> questions;
  int timerSeconds = 900;
  late Timer timer;

  void startTimer(provider) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          // Time is up, you can handle what happens when the timer reaches 0 here
          timer.cancel();
          final status = provider.userstatus;
          provider.options.forEach((element) => {
                if (element.value)
                  {
                    status.quiz = status.quiz! + 1,
                  }
              });

          int totalSeconds = 900 -
              timerSeconds; // Assuming initial time is 15 minutes (900 seconds)
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;
          status.quizTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
          firebaseClient.updateDetails(status);
          Navigator.pushReplacementNamed(context, resultRoute);
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);
    super.initState();
    questions = widget.questions;
    startTimer(provider);
  }

  getCount(HomeProvider provider) {
    int score = 0;
    provider.options.forEach((e) {
      if (e.value) {
        score += 1;
      }
    });
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  provider.questionIndex < questions.length
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${provider.questionIndex + 1}/${questions.length}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              widget.value == 2
                                  ? const Text('')
                                  : CircularPercentIndicator(
                                      radius: 22,
                                      animation: true,
                                      lineWidth: 7,
                                      animationDuration: 5,
                                      percent: 1 - (timerSeconds / 900),
                                      progressColor: baseColor,
                                      center: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${timerSeconds ~/ 60}:${timerSeconds % 60}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                      child: provider.questionIndex < questions.length
                          ? PageView.builder(
                              controller: _pageController,
                              itemCount: questions.length + 1,

                              // physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (value) => {
                                value <= questions.length &&
                                        provider.options.length >= value
                                    ? provider.updateIndex(value)
                                    : _pageController.jumpTo(value + 0.0),
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return ListView(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, bottom: 1),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            bottom: 16,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  questions[provider
                                                          .questionIndex]
                                                      .title
                                                      .toString()
                                                      .trim(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: questions[
                                        //               provider.questionIndex]
                                        //           .image!
                                        //           .isNotEmpty
                                        //       ? [
                                        //           Padding(
                                        //             padding:
                                        //                 const EdgeInsets.all(
                                        //                     8.0),
                                        //             child: SizedBox(
                                        //                 width: 140,
                                        //                 child: Image.network(
                                        //                   questions[provider
                                        //                           .questionIndex]
                                        //                       .image
                                        //                       .toString(),
                                        //                   fit: BoxFit.fill,
                                        //                 )),
                                        //           )
                                        //         ]
                                        //       : [],
                                        // ),
                                        ...buildContainer(provider,
                                            questions[provider.questionIndex]),
                                      ],
                                    ),
                                  ),
                                ]);
                              },
                            )
                          : widget.value == 1
                              ? Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'Right',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          const Text(
                                            'Wrong',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          const Text(
                                            'You choose',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Text(
                                            'Score = ${getCount(provider)}/${questions.length}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: List.generate(
                                            provider.options.length, (index) {
                                          List<Options> option =
                                              questions.firstWhere((element) {
                                            return element.title ==
                                                provider.options[index].key;
                                          }).options!;
                                          return Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider.options[index].key
                                                      .toString()
                                                      .trim(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                  textAlign: TextAlign.start,
                                                ),
                                                for (var o in option)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '• ',
                                                        style: TextStyle(
                                                          color:
                                                              o.value != null &&
                                                                      o.value!
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          o.key
                                                              .toString()
                                                              .trimRight(),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: o.key ==
                                                                      provider
                                                                          .options[
                                                                              index]
                                                                          .option
                                                                  ? Colors.blue
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                const Divider()
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                )
                              : const ResultsScreen()),
                  provider.questionIndex < questions.length
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                    onTap: () {},
                                    child: TextButton(
                                      onPressed: () {
                                        if (_pageController.hasClients &&
                                            provider.questionIndex != 0) {
                                          _pageController.animateToPage(
                                              provider.questionIndex - 1,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.decelerate);
                                        }
                                      },
                                      child: Text(
                                        "< prev",
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            color: provider.questionIndex != 0
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (provider.questionIndex ==
                                            questions.length - 1 &&
                                        widget.value == 2) {
                                      final status = provider.userstatus;
                                      provider.options.forEach((element) {
                                        if (element.value) {
                                          status.quiz = status.quiz! + 1;
                                        }
                                      });
                                      int totalSeconds = 900 -
                                          timerSeconds; // Assuming initial time is 15 minutes (900 seconds)
                                      int minutes = totalSeconds ~/ 60;
                                      int seconds = totalSeconds % 60;
                                      status.quizTime =
                                          '$minutes:${seconds.toString().padLeft(2, '0')}';
                                      firebaseClient.updateDetails(status);
                                      _pageController.animateToPage(
                                          provider.questionIndex + 1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut);
                                    } else if (_pageController.hasClients &&
                                        provider.questionIndex <
                                            questions.length &&
                                        provider.options.length >
                                            provider.questionIndex) {
                                      _pageController.animateToPage(
                                          provider.questionIndex + 1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: provider.questionIndex <
                                                    questions.length &&
                                                provider.options.length >
                                                    provider.questionIndex
                                            ? const Color.fromARGB(
                                                255, 221, 132, 17)
                                            : Colors.grey),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : widget.value == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(lightBlue),
                                  fixedSize: MaterialStateProperty.all(
                                    Size(
                                        MediaQuery.sizeOf(context).width * 0.80,
                                        40),
                                  ),
                                  elevation: MaterialStateProperty.all(4),
                                ),
                                onPressed: () {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                child: const Text(
                                  "Take another test",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),
          ));
    });
  }

  List<Widget> buildContainer(HomeProvider provider, Question question) {
    List<Result> details = provider.options;

    return List.generate(
      question.options!.isEmpty ? 0 : question.options!.length,
      (index) => GestureDetector(
        onTap: () {
          provider.updateOptions(question.title, question.options![index].key,
              question.options![index].value);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: details.length > provider.questionIndex &&
                        details.isNotEmpty
                    ? details[provider.questionIndex].option ==
                            question.options![index].key
                        ? Colors.orange
                        : Colors.black
                    : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Radio(
                  value: true,
                  groupValue: details.length > provider.questionIndex &&
                          details.isNotEmpty
                      ? details[provider.questionIndex].option ==
                              question.options![index].key
                          ? true
                          : false
                      : false,
                  onChanged: (value) {
                    provider.updateOptions(
                        question.title,
                        question.options![index].key,
                        question.options![index].value);
                  },
                  activeColor: Colors.orange,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      question.options![index].key.toString().trim(),
                      style: TextStyle(
                          color: details.length > provider.questionIndex &&
                                  details.isNotEmpty
                              ? details[provider.questionIndex].option ==
                                      question.options![index].key
                                  ? Colors.orange
                                  : Colors.black
                              : Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
