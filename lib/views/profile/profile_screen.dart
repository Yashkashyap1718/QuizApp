// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz/models/user_model.dart';
import 'package:flutter_quiz/provider/home_provider.dart';
import 'package:flutter_quiz/src/databaseProvider.dart';
import 'package:flutter_quiz/src/firebaseClient.dart';
import 'package:flutter_quiz/utils/constants/color_const.dart';
import 'package:flutter_quiz/utils/routes/routes.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user = UserModel();

  bool isImageUploaded = false;
  DatabaseProvider db = DatabaseProvider();

  getUser() async {
    await db.getUsers().then((value) {
      setState(() {
        user = value;

        print('---------user---------${user.username}');
      });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  // File? profilePic;

  // Future<String> uploadImageToFirebaseStorage(File imageFile) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference storageReference =
  //       FirebaseStorage.instance.ref().child('profile_images/$fileName');
  //   UploadTask uploadTask = storageReference.putFile(imageFile);
  //   await uploadTask.whenComplete(() => null);

  //   // Get the download URL of the uploaded image
  //   String imageUrl = await storageReference.getDownloadURL();
  //   return imageUrl;
  // }

  // void updateProfileImageUrlInFirestore(String imageUrl) {
  //   // Assuming you have a Firestore collection named 'users' with a document for each user
  //   // Update the profile image URL in Firestore here
  //   // Replace 'userId' with the actual ID of the user document
  //   String userId = user.uid.toString(); // Replace this with the actual user ID
  //   FirebaseFirestore.instance.collection('users').doc(userId).update({
  //     'profileImageUrl': imageUrl,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure you want to close the App?"),
              actions: [
                TextButton(
                  child: const Text(
                    "No",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // User tapped "No"
                  },
                ),
                TextButton(
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true); // User tapped "Yes"
                  },
                ),
              ],
            );
          },
        );

        // Return true if the user tapped "Yes" and false otherwise
        return shouldPop;
      },
      child: Scaffold(
        body: Consumer<HomeProvider>(
          builder: (_, provider, __) {
            return SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: size.height * .23,
                          width: size.width,
                          decoration: const BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(110)),
                              gradient: LinearGradient(colors: [
                                Color.fromARGB(255, 25, 7, 127),
                                Color.fromARGB(255, 189, 18, 72)
                              ])),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        user.username ?? "Guest",
                                        style: const TextStyle(
                                            color: whiteColor,
                                            fontSize: 20,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      user.phoneNumber ?? "login your account",
                                      style: const TextStyle(
                                          color: whiteColor, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Builder(builder: (context) {
                                  return Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 40, top: 10),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        maxRadius: 50,
                                        backgroundImage:
                                            AssetImage('assets/quiz2.png'),
                                      ),
                                    )
                                    // Padding(
                                    //   padding:  EdgeInsets.only(
                                    //       right: 40, top: 10),
                                    //   child: CircleAvatar(
                                    //     maxRadius: 50,
                                    //     backgroundColor: Colors.grey,
                                    //     child: Text(
                                    //       provider.user.username!.isEmpty
                                    //           ? provider.user.username![0]
                                    //               .toUpperCase()
                                    //           : '',
                                    //       style: TextStyle(
                                    //         fontSize: 32,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // IconButton(
                                    //   onPressed: () async {
                                    //     XFile? selectedImage = await ImagePicker()
                                    //         .pickImage(source: ImageSource.gallery);
                                    //     if (selectedImage != null) {
                                    //       File convertedFile =
                                    //           File(selectedImage.path);
                                    //       // Update profile image URL in Firestore
                                    //       updateProfileImageUrlInFirestore(
                                    //           selectedImage.path);
                                    //       provider.setpic(convertedFile);

                                    //       var user = UserModel(
                                    //           profilePic: selectedImage.path);

                                    //       db.insertUser(user);
                                    //       setState(() {
                                    //         isImageUploaded = true;
                                    //       });
                                    //     } else {
                                    //       ScaffoldMessenger.of(context)
                                    //           .showSnackBar(
                                    //         const SnackBar(
                                    //           content: Text(
                                    //               "Please Select profile pic again"),
                                    //         ),
                                    //       );
                                    //     }
                                    //   },
                                    //   icon: const Icon(Icons.add_a_photo,
                                    //       color: Colors.white),
                                    // ),
                                  ]);
                                }),
                              ],
                            ),
                          ),
                        ),
                        loginButton()
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 27, vertical: size.height * .03),
                        //   child: InkWell(
                        //     onTap: () {
                        //       launchUrl(Uri.parse(
                        //           'https://charansparshfoundation.com/?page_id=932'));
                        //     },
                        //     child: Container(
                        //         height: 50,
                        //         width: size.width,
                        //         decoration: BoxDecoration(
                        //             color: baseColor,
                        //             borderRadius: BorderRadius.circular(15)),
                        //         child: const Center(
                        //             child: Text(
                        //           textAlign: TextAlign.center,
                        //           'Join our Community',
                        //           style: TextStyle(
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.w700,
                        //               color: whiteColor),
                        //         ))),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 27,
                        //   ),
                        //   child: InkWell(
                        //     onTap: () {
                        //       launchUrl(Uri.parse(
                        //           'https://summit.charansparshfoundation.com'));
                        //     },
                        //     child: Container(
                        //         height: 50,
                        //         width: size.width,
                        //         decoration: BoxDecoration(
                        //             color: const Color(0xff00A010),
                        //             borderRadius: BorderRadius.circular(15)),
                        //         child: const Center(
                        //             child: Text(
                        //           textAlign: TextAlign.center,
                        //           'Register for Yuva CSF Summit 2024',
                        //           style: TextStyle(
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.w700,
                        //               color: whiteColor),
                        //         ))),
                        //   ),
                        // ),
                        ,
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ));
          },
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context) async {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String verificationId = args?['verificationId'] ?? '';
    final String smsCode = args?['smsCode'] ?? '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // User chose not to delete
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Step 1: Get the current user
                  User? user = FirebaseAuth.instance.currentUser;
                  UserModel userDet =
                      Provider.of<HomeProvider>(context, listen: false).user;

                  if (user != null) {
                    // // Re-authenticate the user
                    // AuthCredential credential = PhoneAuthProvider.credential(
                    //   verificationId:
                    //       verificationId, // Replace with the actual verification ID
                    //   smsCode: smsCode, // Replace with the actual SMS code
                    // );

                    // await user.reauthenticateWithCredential(credential);

                    // Step 2: Delete user data from Firestore (optional)
                    await FirebaseClient()
                        .deleteUser(userDet.uid, "users")
                        .then((value) async => {
                              if (value)
                                {
                                  await FirebaseClient()
                                      .deleteUser(userDet.uid, "userStatus"),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Something went wrong, Please try later"))),
                                }
                            });

                    // Step 3: Delete the user account from Firebase Authentication
                    await user.delete();
                    await DatabaseProvider().cleanUserTable();

                    Navigator.pushReplacementNamed(context,
                        initialRoute); // Navigate to a different screen

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deleted successfully!'),
                      ),
                    );
                  } else {
                    // Handle the case where the user is not signed in
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User not signed in'),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle errors, e.g., display an error message
                  print('$e');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget loginButton() {
    if (user.uid == null || user.uid!.isEmpty) {
      return ListTile(
        onTap: () {
          Navigator.pushReplacementNamed(context, mobileRoute);
        },
        leading: const Icon(
          Icons.login,
          color: baseColor,
        ),
        title: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          InkWell(
            onTap: () {
              showLogoutConfirmationDialog();
            },
            child: const ListTile(
              leading: Icon(
                Icons.power_settings_new_rounded,
                color: baseColor,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDeleteDialog(context);
            },
            child: const ListTile(
              leading: Icon(
                Icons.delete,
                color: baseColor,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  // Function to logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    await DatabaseProvider().cleanUserTable();
    Navigator.restorablePushNamedAndRemoveUntil(
        context, initialRoute, (route) => true);
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: baseColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
