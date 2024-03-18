// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter_quiz/models/user_model.dart';
import 'package:flutter_quiz/models/userstatus_model.dart';
import 'package:flutter_quiz/provider/home_provider.dart';
import 'package:flutter_quiz/src/databaseProvider.dart';
import 'package:flutter_quiz/src/firebaseClient.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/utils/constants/string_const.dart';
import 'package:flutter_quiz/widgets/loadingWrapper.dart';
import 'package:flutter_quiz/utils/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatelessWidget {
  final String phone;
  final String uid;
  RegisterScreen({super.key, required this.phone, required this.uid});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  DatabaseProvider db = DatabaseProvider();
  FirebaseClient firebaseClient = FirebaseClient();
  bool isGmail(String email) {
    return email.endsWith('@gmail.com');
  }

  // Widget buildButton(context) {
  //   HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);
  //   if (Platform.isAndroid) {
  //     return Column(
  //       children: [
  //         CupertinoButton(
  //           onPressed: () async {
  //             XFile? selectedImage =
  //                 await ImagePicker().pickImage(source: ImageSource.gallery);
  //             if (selectedImage != null) {
  //               File convertedFile = File(selectedImage.path);
  //               provider.setpic(convertedFile);
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("Please Select profile pic again"),
  //                 ),
  //               );
  //             }
  //           },
  //           child: CircleAvatar(
  //             maxRadius: 40,
  //             backgroundImage: (provider.profilePic != null)
  //                 ? FileImage(provider.profilePic!)
  //                 : const NetworkImage(
  //                         'https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png')
  //                     as ImageProvider<Object>,
  //             backgroundColor: Colors.grey,
  //           ),
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.all(8.0),
  //           child: Text('upload image'),
  //         ),
  //       ],
  //     );
  //   } else {
  //     // For non-Android platforms (e.g., iOS), return an empty container
  //     return Text('');
  //   }
  // }

  Future<void> _submitForm(context, p) async {
    if (nameController.text.isNotEmpty &&
            // mobileController.text.isNotEmpty &&
            emailController.text.isNotEmpty
        // studentController.text.isNotEmpty &&
        // collegeController.text.isNotEmpty &&
        // cityController.text.isNotEmpty &&
        // p.agree
        ) {
      // UploadTask uploadTask = FirebaseStorage.instance
      //     .ref()
      //     .child('profilePicture')
      //     .child(const Uuid().v1())
      //     .putFile(p.profilePic);

      // TaskSnapshot taskSnapshot = await uploadTask;
      // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      // Create a UserModel instance
      var user = UserModel(
        uid: uid,
        username: nameController.text,
        phoneNumber:
            mobileController.text.isNotEmpty ? mobileController.text : phone,
        email: emailController.text,
      );

      try {
        // Convert UserModel instance to JSON using its toJson method
        var userData = user.toJson();
        var userStatus =
            UserStatus(quiz: 0, userId: uid, username: nameController.text);
        var statusData = userStatus.toMap();
        await db.cleanUserTable();
        await firebaseClient.addData('userstatus', statusData);
        await firebaseClient.addData('users', userData);
        await db.insertUser(user);

        await db.insertUserStatus(userStatus).then((value) {
          p.updateUser(user, userStatus);
          nameController.clear();
          mobileController.clear();
          emailController.clear();
          Navigator.pushNamedAndRemoveUntil(
              context, bottomBarRoute, (route) => false);
          // p.setpic(null);
          p.hideLoader();
        });
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Something went wrong, please try later $e'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(7)),
                        child: const Center(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
        p.hideLoader();
      }
    } else {
      p.hideLoader();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Fields'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(7)),
                    child: const Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });

      p.setpic(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoadingWrapper(
      child: Scaffold(
        body: Consumer<HomeProvider>(
          builder: (_, provider, __) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, top: 25),
                      child: SizedBox(
                        height: 80,
                        width: size.width,
                        child: Image.asset('assets/quiz2.png'),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    const Text(registerText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // buildButton(context),
                            Container(
                                height: 50,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: grey2Color,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    controller: nameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "required field";
                                      }
                                      return null;
                                    },
                                    onTap: () {},
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        hintText: nameText,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                  height: 50,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: grey2Color,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: TextFormField(
                                      controller: mobileController,
                                      onTap: () {},
                                      validator: (value) {
                                        if (value!.length != 10) {
                                          return "Invalid phone number";
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10)
                                      ],
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                          hintText: mobileText,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(10)),
                                    ),
                                  )),
                            ),
                            Container(
                                height: 50,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: grey2Color,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                              .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }

                                      if (!isGmail(value)) {
                                        return 'Please enter a valid email address';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        hintText: emailText,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10)),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             const TermsAndCondition()));
                      },
                      child: const Text(
                        termsText,
                        style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            decorationColor: baseColor,
                            fontWeight: FontWeight.w700,
                            color: baseColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 27, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Checkbox(
                              activeColor: baseColor,
                              side: const BorderSide(width: 0.7),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              value: provider.agree,
                              onChanged: (value) {
                                provider.setAgree();
                              }),
                          const Flexible(
                            child: Text(
                              byCheckingText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 27, vertical: 18),
                      child: InkWell(
                        onTap: () {
                          provider.setLoader();
                          _submitForm(context, provider);
                        },
                        child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              'Register',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor),
                            ))),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
