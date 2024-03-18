import 'dart:convert';

import 'package:flutter/foundation.dart';

class Question {
  final String? title;
  final List<Options>? options;

  Question({
    this.title,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final dynamic optionsData = json['options'];

    List<Options>? optionsList;

    if (optionsData != null) {
      if (optionsData is String) {
        // Handle the case where optionsData is a String
        try {
          final Map<String, dynamic> parsedOptions =
              jsonDecode(optionsData) as Map<String, dynamic>;

          optionsList = parsedOptions.entries
              .map((e) => Options.fromJson({
                    "key": e.key,
                    "value": e.value,
                  }))
              .toList();
        } catch (e) {
          if (kDebugMode) {
            print("Error ------------- $e");
          }
        }
      } else if (optionsData is Map<String, dynamic>) {
        // Handle the case where optionsData is already a Map
        optionsList = optionsData.entries
            .map((e) => Options.fromJson({
                  "key": e.key,
                  "value": e.value,
                }))
            .toList();
      }
    }

    return Question(
      title: json['title'],
      options: optionsList,
    );
  }
}

class Options {
  String? key;
  bool? value;

  Options({
    this.key,
    this.value,
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      key: json['key'] as String?,
      value: json['value'] as bool?,
    );
  }
}

class Result {
  String key = "";
  String option = "";
  bool value = false;

  Result({required this.key, required this.option, required this.value});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      key: json['key'] as String,
      option: json['option'] as String,
      value: json['value'] as bool,
    );
  }
}
