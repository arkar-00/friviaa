import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  final String difficultyLevel;
  List? questions;
  int _currentQuestionCount = 0;
  int _correctQuestionCount = 0;

  BuildContext context;
  GamePageProvider({required this.context, required this.difficultyLevel}) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    _getQuestionFromAPI();
  }

  Future<void> _getQuestionFromAPI() async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          "amount": _maxQuestions,
          "type": 'boolean',
          'difficulty': difficultyLevel,
        },
      );
      questions = response.data['results'] as List?;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load questions: $e')));
    }
  }

  String getCurrentQuestionText() {
    if (questions != null && _currentQuestionCount < questions!.length) {
      return "${_currentQuestionCount + 1}. ${questions![_currentQuestionCount]['question']}";
    } else {
      return "There are no more questions";
    }
  }

  void answerQuestion(String answer) async {
    if (questions == null || _currentQuestionCount >= questions!.length) return;

    final correctAnswer =
        questions?.elementAt(_currentQuestionCount)['correct_answer'];
    final isCorrect = correctAnswer == answer;
    if (isCorrect) {
      _correctQuestionCount++;
    }

    _currentQuestionCount++;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isCorrect ? const Color(0xFF26a69a) : const Color(0xFFef5350),
            title: Icon(
              isCorrect ? Icons.check_circle : Icons.cancel_sharp,
              color: Colors.white,
            ),
            content: Text(
              isCorrect
                  ? "You answered correctly."
                  : "The correct answer was: $correctAnswer",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
    );
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    if (_currentQuestionCount == _maxQuestions) {
      endGame();
    } else {
      notifyListeners();
    }
  }

  Future<void> endGame() async {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Text(
            "End Game!",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          content: Text(
            "Score: $_correctQuestionCount/$_maxQuestions",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        );
      },
    );
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context);
    Navigator.pop(context);
    _currentQuestionCount = 0;
  }
}
