import 'package:adhd_helper/constants/appbar.dart';
import 'package:flutter/material.dart';
import '../games/jeux1.dart';
import 'notebook_screen.dart';
import 'lancer_routine_screen.dart';
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:adhd_helper/src/widgets/submit_button.dart'; // Import the SubmitButton widget
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CognitiveActiviteScreen extends StatefulWidget {
  const CognitiveActiviteScreen({super.key});

  @override
  State<CognitiveActiviteScreen> createState() =>
      _CognitiveActiviteScreenState();
}

class _CognitiveActiviteScreenState extends State<CognitiveActiviteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Text(
    AppLocalizations.of(context)!.mentalTechniquesForKids,
                    textAlign: TextAlign.center,
                    style:
                        bigTextstyle, // Use the same text style as in KidsHomeScreen
                  ),
                  const SizedBox(height: 50.0),
                  // Use SubmitButton instead of ElevatedButton
                  SubmitButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotebookScreen(),
                        ),
                      );
                    },
  buttonText: AppLocalizations.of(context)!.ideaNotebook,
                  ),
                  const SizedBox(height: 20.0),
                  SubmitButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LancerRoutineScreen(),
                        ),
                      );
                    },
  buttonText: AppLocalizations.of(context)!.dailySuccesses,
                  ),
                  const SizedBox(height: 20.0),
                  SubmitButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => jeux1(),
                        ),
                      );
                    },
  buttonText: AppLocalizations.of(context)!.startPlaying,
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
