import 'package:flutter/material.dart';
import 'package:friviaa/providers/game_page_provider.dart';
import 'package:provider/provider.dart';

class GamePage extends StatelessWidget {
  double? _deviceHeight, _deviceWidth;

  GamePageProvider? _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_context) => GamePageProvider(context: context),
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (context) {
        _pageProvider = context.watch<GamePageProvider>();
        if (_pageProvider!.questions != null) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(26, 40, 108, 1.0),
                    Color.fromRGBO(0, 0, 0, 1.0),
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: _deviceHeight! * 0.05),
              child: _gameUI(),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      },
    );
  }

  Widget _gameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _questionText(),
        Column(
          children: [
            _trueButton(),
            SizedBox(height: _deviceHeight! * 0.01),
            _falseButton(),
          ],
        ),
      ],
    );
  }

  Widget _questionText() {
    return Text(
      _pageProvider!.getCurrentQuestionText(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _trueButton() {
    return MaterialButton(
      onPressed: () {
        _pageProvider?.answerQuestion("True");
      },
      color: const Color(0xFF26a69a),
      minWidth: _deviceWidth! * 0.80,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "True",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }

  Widget _falseButton() {
    return MaterialButton(
      onPressed: () {
        _pageProvider?.answerQuestion("False");
      },
      color: const Color(0xFFef5350),
      minWidth: _deviceWidth! * 0.80,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "False",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }
}
