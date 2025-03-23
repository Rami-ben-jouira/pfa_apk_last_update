import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/conners_questionnaire_screen.dart';
import 'package:adhd_helper/src/screens/questionnaire_screen.dart';
import 'package:adhd_helper/src/widgets/app_drawer.dart';
import 'package:adhd_helper/src/widgets/message_widget.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import '../../constants/textstyle.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'doctors_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _storeService = FirestoreService();

  List<Message> messages = [];
  bool hasQuestionnaire = false;
  bool hasTest = false;
  @override
  void initState() {
    super.initState();
    checkUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          background,
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
            child: FutureBuilder(
              future: _authService.checkEmailVerification(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 0,
                    width: 0,
                  );
                } else {
                  bool isverified = snapshot.data!;
                  // If the user is not verified, show a message
                  if (!isverified) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.verifyEmailMessage,
                            style: smallTextstyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SubmitButton(
                              onPressed: () async {
                                bool newvarable =
                                    await _authService.checkEmailVerification();
                                setState(() {
                                  isverified = newvarable;
                                });
                              },
                              buttonText: AppLocalizations.of(context)!
                                  .checkEmailVerification),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: !(hasQuestionnaire && hasTest),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .youStillDidNot,
                                        style: smallTextstyle,
                                      ),
                                    ),
                                    Visibility(
                                        visible: !hasQuestionnaire,
                                        child: SubmitButton(
                                            onPressed: () =>
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const QuestionnaireSreen(),
                                                  ),
                                                ),
                                            buttonText:
                                                AppLocalizations.of(context)!
                                                    .startQuestionnaire)),
                                    Visibility(
                                        visible: !hasTest,
                                        child: SubmitButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DoctorsScreen(),
                                                ),
                                              );
                                            },
                                            buttonText:
                                                AppLocalizations.of(context)!
                                                    .chooseDoctor)),
                                    SubmitButton(
                                        onPressed: () =>
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ConnersSreen(),
                                              ),
                                            ),
                                        buttonText: "start conners")
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<Message>>(
                              future: _storeService.getMessages(
                                  _authService.getCurrentUser()!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Display a loading indicator while waiting for the data
                                  return const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle error case
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  // Handle empty data case
                                  return Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .noMessagesAvailable,
                                      style: midTextstyle,
                                    ),
                                  );
                                } else {
                                  messages = snapshot.data!;

                                  return Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .doctorsNote,
                                        style: bigTextstyle,
                                      ),
                                      const SizedBox(height: 30.0),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: messages.length,
                                          itemBuilder: (context, index) {
                                            return MessageWidget(
                                              senderName:
                                                  messages[index].senderName,
                                              topic: messages[index].topic,
                                              messageContent: messages[index]
                                                  .messageContent,
                                              timestamp:
                                                  messages[index].timestamp,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkUserDetails() async {
    // Assume getQuestionnaire and getTest are asynchronous functions
    hasQuestionnaire = await _storeService
        .haveQuestionnaire(_authService.getCurrentUser()!.uid);
    hasTest = await _storeService
        .haveDoctorUidFromUser(_authService.getCurrentUser()!.uid);

    // Update the UI state after obtaining results
    if (mounted) {
      setState(() {});
    }
  }
}




//       
