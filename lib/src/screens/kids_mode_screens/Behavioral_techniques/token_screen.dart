import 'package:flutter/material.dart';
import 'package:adhd_helper/constants/appbar.dart'; // Import the appBar
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TokenScreen extends StatefulWidget {
  @override
  _TokenScreenState createState() => _TokenScreenState();
}
class _TokenScreenState extends State<TokenScreen> {
  int tokens = 0;

  void incrementTokens() {
    setState(() {
      tokens++;
      // Display a message when tokens reach 5
      if (tokens == 5) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(150, 33, 150, 243), // Set the background color
              title: Text(
                AppLocalizations.of(context)!.congratulations, // Translated text
                style: bigTextstyle, // Use the same text style
              ),
              content: Text(
                AppLocalizations.of(context)!.tokensMessage, // Translated text
                style: midTextstyle, // Use the same text style
                textDirection: TextDirection.rtl,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.okay, // Translated text
                    style: midTextstyle, // Use the same text style
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          Center(
            child: SingleChildScrollView(
              // Make the content scrollable
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.earnTokens, // Translated text
                    style: bigTextstyle, // Use the same text style
                  ),
                  const SizedBox(height: 20),
                  DragTarget<String>(
                    onAccept: (data) {
                      if (data == 'increment') {
                        incrementTokens();
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Center(
                        child: Image.asset(
                          'assets/images/cadeau.png',
                          width: 194,
                          height: 168,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Draggable<String>(
                        data: 'increment',
                        feedback: Image.asset(
                          'assets/images/rire.png',
                          width: 88,
                          height: 88,
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            'assets/images/rire.png',
                            width: 88,
                            height: 88,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/rire.png',
                          width: 88,
                          height: 88,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 26.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${AppLocalizations.of(context)!.result} $tokens', // Translated text
                              style: bigTextstyle, // Use the same text style
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}