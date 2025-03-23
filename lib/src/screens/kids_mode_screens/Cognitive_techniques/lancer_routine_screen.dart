import 'package:flutter/material.dart';
import 'routine_screen.dart';
import 'package:adhd_helper/constants/appbar.dart'; // Import the appBar
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class LancerRoutineScreen extends StatefulWidget {
  @override
  _LancerState createState() => _LancerState();
}

class _LancerState extends State<LancerRoutineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                Image.asset(
                  'assets/images/imageQuestion.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 10),
                Text(
  AppLocalizations.of(context)!.nextActivityDescription,
                  textAlign: TextAlign.center,
                  style: bigTextstyle.copyWith(fontSize: 16.0), // Use the same text style
                ),
                const SizedBox(height: 15.0),
_buildInstruction(AppLocalizations.of(context)!.tryAgain),
_buildInstruction(AppLocalizations.of(context)!.sometimesSucceed),
_buildInstruction(AppLocalizations.of(context)!.mostlySucceed),
                const SizedBox(height: 45.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoutineScreen(),
                      ),
                    );
                  },
                  child: Text(
    AppLocalizations.of(context)!.startExercises,
                    style: bigTextstyle.copyWith(
                      fontSize: 28.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String instruction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
      child: Text(
        instruction,
        textAlign: TextAlign.start,
        style: midTextstyle.copyWith(
          color: Colors.redAccent,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}