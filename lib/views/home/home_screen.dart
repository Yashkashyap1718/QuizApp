import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quiz/models/flutter_topics_model.dart';
import 'package:flutter_quiz/src/firebaseClient.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/views/newCard.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Future<List<String>> getCategories() async {
  //   List<String> categories = [];
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot =
  //         await FirebaseFirestore.instance.collection('Quiz').get();
  //     for (var doc in snapshot.docs) {
  //       categories.add(doc.id);
  //     }
  //     print('Fetched categories: $categories');
  //     return categories;
  //   } catch (e) {
  //     print('Error fetching categories: $e');
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> getCategories() async {
    List<Map<String, dynamic>> categories = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Quiz').get();
      for (var doc in snapshot.docs) {
        categories.add({
          'name': doc.id,
          'image': doc['image'],
        });
      }
      print('Fetched categories: $categories');
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF4993FA);
    const Color bgColor3 = Color(0xFF5170FD);
    return Scaffold(
      backgroundColor: bgColor3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: bgColor3,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.24),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                      spreadRadius: -10,
                      blurStyle: BlurStyle.outer,
                    )
                  ],
                ),
                child: Image.asset(
                  "assets/quiz2.png",
                  scale: 5,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome to Your ",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: 21,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      for (var i = 0; i < "Quiz!!!".length; i++) ...[
                        TextSpan(
                          text: "Quiz!!!"[i],
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 21 + i.toDouble(),
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: baseColor,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final categories = snapshot.data;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories!.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => NewCard(
                          //       typeOfTopic: topicsData.topicQuestions,
                          //       topicName: topicsData.topicName,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Card(
                          color: bgColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon(
                                //   topicsData.topicIcon,
                                //   color: Colors.white,
                                //   size: 55,
                                // ),
                                Image.network(
                                  category['image'],
                                  scale: 6,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${category['name']}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
