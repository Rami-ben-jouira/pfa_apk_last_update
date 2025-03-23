import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:adhd_helper/src/models/Breathing.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'emotions_activites_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BreathingScreen extends StatefulWidget {
  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  DateTime? startTime;
  DateTime? endTime;
  bool isStartClicked = false; // To control the Stop button
  final FirestoreService _storeService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(150, 33, 150, 243),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .breathingExerciseDescription,
                      textAlign: TextAlign.right,
                      style: midTextstyle.copyWith(
                          fontSize: 20), // Use the same text style
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset('assets/images/main.png'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              startTime = DateTime.now();
                              isStartClicked = true; // Enable Stop button
                              _saveStartTimeToFirestore();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.start),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: isStartClicked
                              ? () {
                                  setState(() {
                                    endTime = DateTime.now();
                                    _saveEndTimeToFirestore();
                                    Navigator.pop(context);
                                  });
                                }
                              : null, // Disable if start button is not clicked
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.stop),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveStartTimeToFirestore() async {
    // Logic to save start time to Firestore
  }

  void _saveEndTimeToFirestore() async {
    String? idEnfant = await _storeService.getCurrentChildId();
    if (startTime != null && endTime != null) {
      Breathing breathing = Breathing(
        childId: idEnfant!,
        startTime: startTime!.toIso8601String(),
        endTime: endTime!.toIso8601String(),
        titre: 'Exercice de respiration',
      );
      _storeService.addBreathing(breathing);
    }
  }
}
