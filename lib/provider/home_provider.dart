import 'package:flutter/material.dart';
import 'package:flutter_quiz/models/user_model.dart';

class HomeProvider extends ChangeNotifier {
  UserModel user = UserModel();

  bool loading = false;

  bool agree = false;

  setAgree() {
    agree = !agree;
    notifyListeners();
  }

  updateUser(user) {
    user = user;
    notifyListeners();
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
}
