import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quiz/models/question_model.dart';
import 'package:flutter_quiz/models/user_model.dart';
import 'package:flutter_quiz/models/userstatus_model.dart';

class HomeProvider extends ChangeNotifier {
  UserModel user = UserModel();
  UserStatus userstatus = UserStatus();
  int videos = 0;
  int pageIndex = 0;
  int questionIndex = 0;
  File? profilePic;
  List<Result> options = [];
  // Loading
  bool loading = false;

  // terms&conditions
  bool agree = false;

  // Set Page Index
  updateIndex(v) {
    questionIndex = v;
    notifyListeners();
  }

  updatepage(v) {
    pageIndex = v;
  }

// set Loading state
  setLoader() {
    loading = true;
    notifyListeners();
  }

  // remove loader
  hideLoader() {
    loading = false;
    notifyListeners();
  }

  // Set Profile pic
  setpic(file) {
    profilePic = file;
    notifyListeners();
  }

  setAgree() {
    agree = !agree;
    notifyListeners();
  }

  updateOptions(title, option, value) {
    final existingOption = options.firstWhere((element) => element.key == title,
        orElse: () => Result(key: title, value: value, option: option));

    existingOption.value = value;
    existingOption.option = option;
    if (!options.contains(existingOption)) {
      options.add(existingOption);
    }
    notifyListeners();
  }
  // void updateOptions(title, option, value) {
  //   Result existingOption;
  //   try {
  //     existingOption = options.firstWhere(
  //       (element) => element.key == title,
  //     );
  //   } catch (e) {
  //     existingOption = Result(key: title, value: false, option: '');
  //   }

  //   existingOption.value = value;
  //   existingOption.option = option;

  //   if (!options.contains(existingOption)) {
  //     options.add(existingOption);
  //   }

  //   notifyListeners();
  // }

  clearOptions() {
    if (options.isNotEmpty) {
      options.clear();
      questionIndex = 0;
    }
    notifyListeners();
  }

  updateUser(user, status) {
    user = user;
    userstatus = status;
    notifyListeners();
  }

  updateVideos(v) {
    videos = v;
    notifyListeners();
  }
}
