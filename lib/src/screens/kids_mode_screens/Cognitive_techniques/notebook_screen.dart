import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:adhd_helper/src/screens/kids_mode_screens/Cognitive_techniques/notebook_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotebookScreen extends StatefulWidget {
  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Text(
                  AppLocalizations.of(context)!.useToolWhenFacingProblem,
                  textAlign: TextAlign.center,
                  style: bigTextstyle.copyWith(
                      fontSize: 20), // Use the same text style
                ),
                const SizedBox(height: 20),
                _buildButton(
                  text: AppLocalizations.of(context)!.situation,
                  backgroundColor: const Color(0xFFF0E1E3),
                  imagePath: 'assets/images/image1.png',
                ),
                const SizedBox(height: 10),
                _buildButton(
                  text: AppLocalizations.of(context)!.idea,
                  backgroundColor: const Color(0xFFF0CCD1),
                  imagePath: 'assets/images/image2.png',
                ),
                const SizedBox(height: 10),
                _buildButton(
                  text: AppLocalizations.of(context)!.feelings,
                  backgroundColor: const Color(0xFFF2BBC3),
                  imagePath: 'assets/images/image3.png',
                ),
                const SizedBox(height: 10),
                _buildButton(
                  text: AppLocalizations.of(context)!.behavior,
                  backgroundColor: const Color(0xFFEC99A4),
                  imagePath: 'assets/images/image4.png',
                ),
                const SizedBox(height: 10),
                _buildButton(
                  text: AppLocalizations.of(context)!.result,
                  backgroundColor: const Color(0xFFEC99A4),
                  imagePath: 'assets/images/image2.png',
                ),
                const SizedBox(height: 60),
                _buildStartButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    String? imagePath,
  }) {
    return Container(
      width: 320,
      height: 65,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: 50.0,
                height: 45.0,
              ),
            if (imagePath != null) const SizedBox(width: 10.0),
            Text(
              text,
              style: midTextstyle.copyWith(
                  fontSize: 20), // Use the same text style
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: 320,
      height: 65,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotebookFormsScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFF4CE98),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          textStyle: const TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.startUsingTool,
              style: midTextstyle.copyWith(
                  fontSize: 20), // Use the same text style
            ),
            const SizedBox(width: 10.0),
            Image.asset(
              'assets/images/fleshe.png',
              width: 20.0,
              height: 20.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
