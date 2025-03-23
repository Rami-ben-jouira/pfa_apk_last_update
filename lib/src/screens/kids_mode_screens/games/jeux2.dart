import 'dart:math';
import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:flutter/material.dart';
import '../Cognitive_techniques/cognitive_activites_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class jeux2 extends StatefulWidget {
  @override
  _jeux2State createState() => _jeux2State();
}

class _jeux2State extends State<jeux2> {
  int _indexLapin = Random().nextInt(4);
  int _flops = 0;
  int _pafs = 0;
  int _currentLevel = 1;

  void gererTape(int index) {
    print('Bouton ' + index.toString());
    if (this._indexLapin == index) {
      this._pafs++;
      _indexLapin = Random().nextInt(4);
    } else {
      this._flops++;
    }
    checkLevelCompletion(context);
    setState(() {});
  }

  void checkLevelCompletion(BuildContext context) {
    if (_pafs >= _currentLevel * 5) {
      _currentLevel++;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.amber.shade100, // Custom background color
            title: null,
            content: Text(
              '${AppLocalizations.of(context)!.congratulationsLevel} $_currentLevel.', // Translated text
              style: midTextstyle.copyWith(
                  color: Colors.black), // Use the same text style
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CognitiveActiviteScreen(),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.okay, // Translated text
                  style: midTextstyle.copyWith(
                      color: Colors.blue), // Use the same text style
                ),
              ),
            ],
          );
        },
      );
    }
  }

// Reusable function to build buttons
  MaterialButton _buildButton(int index, String correctImagePath,
      String correctText, String incorrectImagePath, String incorrectText) {
    return MaterialButton(
      onPressed: () {
        gererTape(index);
      },
      child: this._indexLapin == index
          ? Column(
              children: [
                Image.asset(correctImagePath, width: 45, height: 45),
                const SizedBox(height: 5),
                Text(
                  correctText,
                  style: midTextstyle.copyWith(
                      fontSize: 16), // Use the same text style
                ),
              ],
            )
          : Column(
              children: [
                Image.asset(incorrectImagePath, width: 50, height: 50),
                const SizedBox(height: 5),
                Text(
                  incorrectText,
                  style: midTextstyle.copyWith(
                      fontSize: 16), // Use the same text style
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(this._indexLapin);

    // Use the reusable function to create buttons
    var b0 = _buildButton(
        0,
        'assets/images/rouge.png',
        AppLocalizations.of(context)!.redColor,
        'assets/images/vert.png',
        AppLocalizations.of(context)!.greenColor);
    var b1 = _buildButton(
        1,
        'assets/images/rouge.png',
        AppLocalizations.of(context)!.redColor,
        'assets/images/bleu.png',
        AppLocalizations.of(context)!.blueColor);
    var b2 = _buildButton(
        2,
        'assets/images/rouge.png',
        AppLocalizations.of(context)!.redColor,
        'assets/images/rose.png',
        AppLocalizations.of(context)!.pinkColor);
    var b3 = _buildButton(
        3,
        'assets/images/rouge.png',
        AppLocalizations.of(context)!.redColor,
        'assets/images/orange.png',
        AppLocalizations.of(context)!.orangeColor);

    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.correct}: ${this._pafs.toString()}',
                      style: midTextstyle.copyWith(
                        color: Colors.green,
                        fontSize: 20,
                      ), // Use the same text style
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.wrong}: ${this._flops.toString()}",
                      style: midTextstyle.copyWith(
                        color: Colors.red,
                        fontSize: 20,
                      ), // Use the same text style
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.gameLevel}: ${this._currentLevel.toString()}",
                      style: midTextstyle.copyWith(
                          fontSize: 20), // Use the same text style
                    ),
                  ],
                ),
                Text(
                  AppLocalizations.of(context)!
                      .findTheRedColor, // Translated text
                  style: bigTextstyle.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ), // Use the same text style
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [b0, b1],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [b2, b3],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
