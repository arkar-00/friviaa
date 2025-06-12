import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  List? questions;
  int _currentQuestionCount = 0;

  BuildContext context;
  GamePageProvider({required this.context}) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _getQuestionFromAPI();
  }

  Future<void> _getQuestionFromAPI() async {
    try {
      var _response = await _dio.get(
        '',
        queryParameters: {
          "amount": 10,
          "type": 'boolean',
          'difficulty': 'easy',
        },
      );
      var _data = _response.data; // Use _response.data directly
      questions = _data['results'];
      print(questions);
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load questions: $e')));
    }
  }

  String getCurrentQuestionText() {
    return questions![_currentQuestionCount]['question'];
  }
}
