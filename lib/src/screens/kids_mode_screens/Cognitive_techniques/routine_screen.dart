import 'package:adhd_helper/src/models/routines.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cognitive_activites_screen.dart';
import 'package:adhd_helper/constants/appbar.dart'; // Import the appBar
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _JourEnfantsState createState() => _JourEnfantsState();
}

class _JourEnfantsState extends State<RoutineScreen> {
  final FirestoreService _storeService = FirestoreService();

  final List<String> imageUrls = [
    'assets/images/fruit.png',
    'assets/images/lampe.png',
    'assets/images/j.png',
    'assets/images/gf.png',
    'assets/images/dents.png',
    'assets/images/lit.png',
    'assets/images/jouets.png',
    'assets/images/table.png',
    'assets/images/s.png',
    'assets/images/v.png',
  ];



  Map<String, String> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    List<String> questions = [
      AppLocalizations.of(context)!.eatFruitsAndVegetables,
      AppLocalizations.of(context)!.turnOffLights,
      AppLocalizations.of(context)!.takeCareOfMyself,
      AppLocalizations.of(context)!.findActivityWithSibling,
      AppLocalizations.of(context)!.brushTeethAlone,
      AppLocalizations.of(context)!.makeBed,
      AppLocalizations.of(context)!.tidyToys,
      AppLocalizations.of(context)!.helpSetTable,
      AppLocalizations.of(context)!.cleanUpAfterEating,
      AppLocalizations.of(context)!.putClothesInLaundry,
    ];

    List<String> answers = [
  AppLocalizations.of(context)!.mostlySucceed,
  AppLocalizations.of(context)!.sometimesSucceed,
  AppLocalizations.of(context)!.tryAgain,
];
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 210.0),
                    buildFixedItem("2"),
                    buildFixedItem("1"),
                    buildFixedItem("0"),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color.fromARGB(150, 33, 150, 243),
                      child: ListTile(
                        title: Column(
                          children: [
                            Image.asset(
                              imageUrls[index],
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              questions[index],
                              style: smallTextstyle, // Use the same text style
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: answers.map((answer) {
                            return Radio<String>(
                              value: answer,
                              groupValue: selectedAnswers[questions[index]],
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswers[questions[index]] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool allQuestionsAnswered = true;
          for (String question in questions) {
            if (selectedAnswers[question] == null) {
              allQuestionsAnswered = false;
              break;
            }
          }
          if (allQuestionsAnswered) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color.fromARGB(
                    150, 33, 150, 243), // Custom background color
                title: Text(
                  AppLocalizations.of(context)!.confirmation,
                  style: bigTextstyle.copyWith(color: Colors.black),
                ),
                content: Text(
                  AppLocalizations.of(context)!.saveAnswersConfirmation,
                  style: midTextstyle.copyWith(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: midTextstyle.copyWith(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      saveResponses(selectedAnswers);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!
                                .answersSavedSuccessfully,
                            style: midTextstyle.copyWith(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.confirm,
                      style: midTextstyle.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color.fromARGB(
                    150, 33, 150, 243), // Custom background color
                title: Text(
                  AppLocalizations.of(context)!.warning,
                  style: bigTextstyle.copyWith(color: Colors.black),
                ),
                content: Text(
                  AppLocalizations.of(context)!.answerAllQuestions,
                  style: midTextstyle.copyWith(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "حسنا",
                      style: midTextstyle.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget buildFixedItem(String text) {
    return Row(
      children: [
        Container(
          width: 40.0,
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          color: Color.fromARGB(150, 33, 150, 243),
          child: Column(
            children: [
              Text(
                text,
                style: smallTextstyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> saveResponses(Map<String, String> ReponseEnfants) async {
    String? idEnfant = await _storeService.getCurrentChildId();
    Routines routine = Routines(
      childId: idEnfant!,
      responses: ReponseEnfants,
      timestamp: FieldValue.serverTimestamp(),
    );
    _storeService.addRoutine(routine);
    print("Réponses enregistrées : $ReponseEnfants");
  }

  Future<List<String>> _fetchParentEnfantsId(String parentId) async {
    DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
        .collection('Parent')
        .doc(parentId)
        .get();
    if (parentSnapshot.exists) {
      Map<String, dynamic>? data =
          parentSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('enfantsId')) {
        List<dynamic> enfantsId = data['enfantsId'] ?? [];
        return enfantsId.cast<String>();
      }
    }
    return [];
  }
}
