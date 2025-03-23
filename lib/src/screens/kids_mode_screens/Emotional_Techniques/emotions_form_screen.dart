import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:adhd_helper/src/models/emotions.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'emotions_activites_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EmotionFormScreen extends StatefulWidget {
  @override
  State<EmotionFormScreen> createState() => _EmotionFormScreenState();
}

class _EmotionFormScreenState extends State<EmotionFormScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();
  final FirestoreService _storeService = FirestoreService();

  ButtonListScreen() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateController.text = formattedDate;
  }

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                Text(
                  AppLocalizations.of(context)!.expressYourFeelings,
                  textAlign: TextAlign.center,
                  style: bigTextstyle.copyWith(
                      fontSize: 20), // Use the same text style
                ),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _dateController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.todayDate,
                          contentPadding: const EdgeInsets.only(right: 20),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _eventController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.event,
                          contentPadding: const EdgeInsets.only(right: 20),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.tapImageToExpressFeelings,
                        textAlign: TextAlign.center,
                        style: midTextstyle.copyWith(
                            fontSize: 20), // Use the same text style
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildEmotionColumn(
                              context, 'assets/images/em1.png', AppLocalizations.of(context)!.fear),
                          const SizedBox(width: 15),
                          _buildEmotionColumn(
                              context, 'assets/images/em2.png', AppLocalizations.of(context)!.disgust),
                          const SizedBox(width: 15),
                          _buildEmotionColumn(
                              context, 'assets/images/em5.png', AppLocalizations.of(context)!.anger),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildEmotionColumn(
                              context, 'assets/images/em4.png', AppLocalizations.of(context)!.sadness),
                          const SizedBox(width: 15),
                          _buildEmotionColumn(
                              context, 'assets/images/em6.png', AppLocalizations.of(context)!.surprise),
                          const SizedBox(width: 15),
                          _buildEmotionColumn(
                              context, 'assets/images/em7.png', AppLocalizations.of(context)!.joy),
                        ],
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildEmotionColumn(
      BuildContext context, String imagePath, String emotionText) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            String? idEnfant = await _storeService.getCurrentChildId();
            if (idEnfant != null) {
              Emotions emotions = Emotions(
                childId: idEnfant,
                date: _dateController.text,
                emotion: emotionText,
                event: _eventController.text,
                timestamp: FieldValue.serverTimestamp(),
              );
              _storeService.addEmotions(emotions);


              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor:
                      Colors.amber.shade100, // Custom background color
                  title: null,
                  content: Text(
                  AppLocalizations.of(context)!.emotionRecordedSuccessfully(emotionText),
                    style: midTextstyle.copyWith(
                        color: Colors.black), // Use the same text style
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                       
                      },
                      child: Text(
                      AppLocalizations.of(context)!.ok,
                        style: midTextstyle.copyWith(
                            color: Colors.blue), // Use the same text style
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          child: Image.asset(imagePath, width: 65, height: 65),
        ),
        const SizedBox(height: 10),
        Text(
          emotionText,
          style: midTextstyle.copyWith(fontSize: 20), // Use the same text style
        ),
      ],
    );
  }
}
