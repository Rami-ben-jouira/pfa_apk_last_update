import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:adhd_helper/src/screens/kids_mode_screens/Emotional_Techniques/emotions_activites_screens.dart';
import 'package:adhd_helper/src/screens/kids_mode_screens/Behavioral_techniques/behavioral_activites_screen.dart';
import 'package:adhd_helper/src/screens/kids_mode_screens/Cognitive_techniques/cognitive_activites_screen.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:adhd_helper/utils/kids_mode_activation.dart';
import 'package:local_auth/local_auth.dart';

import '../../../constants/background.dart';
import '../../../constants/textstyle.dart';
import 'kid_test_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KidsHomeScreen extends StatefulWidget {
  const KidsHomeScreen({super.key});

  @override
  State<KidsHomeScreen> createState() => _KidsHomeScreenState();
}

class _KidsHomeScreenState extends State<KidsHomeScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          background,
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.kidsMode,
                    style: bigTextstyle,
                  ),
                  const SizedBox(height: 30.0),
                  SubmitButton(
                      onPressed: () {
                        saveValue(
                          true,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const KidTest(),
                          ),
                        );
                      },
                      buttonText: AppLocalizations.of(context)!.playTime),
                  SubmitButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CognitiveActiviteScreen(),
                          ),
                        );
                      },
                      buttonText: AppLocalizations.of(context)!.cognitiveActivities),
                  SubmitButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BehavioralActivitesScreen(),
                          ),
                        );
                      },
                      buttonText: AppLocalizations.of(context)!.behavioralActivities),
                  SubmitButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EmotionsActivitesScreens(),
                          ),
                        );
                      },
                      buttonText: AppLocalizations.of(context)!.emotionalActivities),
                  SubmitButton(
                      onPressed: () {
                        _authenticate();
                      },
                      buttonText: AppLocalizations.of(context)!.exit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: AppLocalizations.of(context)!.scanFingerprint,
      );
    } catch (e) {
      print("Error during fingerprint authentication: $e");
    }

    if (authenticated) {
      saveValue(false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      // Continue to the main part of the app
    } else {
      // You can choose to show an error message or take other actions
      print('Fingerprint authentication failed');
    }
  }
}
