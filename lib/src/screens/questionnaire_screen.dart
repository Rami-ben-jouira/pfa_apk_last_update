import 'package:adhd_helper/src/models/questionnaire.dart';
import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:adhd_helper/src/screens/login_screen.dart';
import 'package:adhd_helper/src/services/auth_service.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:adhd_helper/src/widgets/show_dialog.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/background.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../widgets/radio_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionnaireSreen extends StatefulWidget {
  const QuestionnaireSreen({super.key});

  @override
  State<QuestionnaireSreen> createState() => _QuestionnaireSreenState();
}

class _QuestionnaireSreenState extends State<QuestionnaireSreen> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirestoreService storeService = FirestoreService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int childAge = 0;
  int motherAge = 0;
  bool _childAgeValidator = true;
  bool _motherAgeValidator = true;
  List<int> answers = List.filled(18, -1);

  void updateAnswer(int index, int answer) {
    setState(() {
      answers[index] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> malade = [
      AppLocalizations.of(context)!.allergiesQuestion,
      AppLocalizations.of(context)!.arthritisQuestion,
      AppLocalizations.of(context)!.asthmaQuestion,
      AppLocalizations.of(context)!.brainInjuryQuestion,
      AppLocalizations.of(context)!.headachesQuestion,
      AppLocalizations.of(context)!.anxietyQuestion,
      AppLocalizations.of(context)!.depressionQuestion,
    ];
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            background,
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 40.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.questionnaire,
                        style: bigTextstyle,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6CA8F1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .childAgeQuestion,
                                        style: smallTextstyle),
                                    TextFormField(
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.only(top: 14.0),
                                        hintText: AppLocalizations.of(context)!
                                            .childAge,
                                        hintStyle: kHintTextStyle,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // return AppLocalizations.of(context)!
                                          //     .enterChildAge;
                                          _childAgeValidator = false;
                                          return null;
                                        } else {
                                          _childAgeValidator = true;
                                          return null;
                                        }
                                      },
                                      onSaved: (newValue) =>
                                          childAge = int.parse(newValue!),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            RadioFormWidget(
                              question: AppLocalizations.of(context)!
                                  .childSexQuestion,
                              answers: [
                                AppLocalizations.of(context)!.male,
                                AppLocalizations.of(context)!.female,
                              ],
                              onSelectionChanged: (value) =>
                                  updateAnswer(1, value),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6CA8F1),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .motherAgeQuestion,
                                        style: smallTextstyle),
                                    TextFormField(
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'OpenSans',
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.only(top: 14.0),
                                        hintText: AppLocalizations.of(context)!
                                            .motherAge,
                                        hintStyle: kHintTextStyle,
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // return AppLocalizations.of(context)!
                                          //     .enterMotherAge;
                                          _motherAgeValidator = false;
                                          return null;
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (newValue) =>
                                          motherAge = int.parse(newValue!),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            for (int i = 0; i < 7; i++)
                              RadioFormWidget(
                                  question: malade[i],
                                  answers: [
                                    AppLocalizations.of(context)!.no,
                                    AppLocalizations.of(context)!.yes,
                                  ],
                                  onSelectionChanged: (value) =>
                                      updateAnswer(i + 3, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .insuranceQuestion,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(10, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .alcoholDrugProblemQuestion,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(11, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .familyStructureQuestion,
                                answers: [
                                  AppLocalizations.of(context)!.twoParents,
                                  AppLocalizations.of(context)!.singleParent,
                                  AppLocalizations.of(context)!.other,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(12, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .motherEducationQuestion,
                                answers: [
                                  AppLocalizations.of(context)!
                                      .lessThanHighSchool,
                                  AppLocalizations.of(context)!.highSchool,
                                  AppLocalizations.of(context)!
                                      .greaterThanHighSchool,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(13, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .lowBirthWeight15kg,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(14, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .lowBirthWeight25kg,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(15, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .prematureBirthQuestion,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(16, value)),
                            RadioFormWidget(
                                question: AppLocalizations.of(context)!
                                    .incomePovertyLevelQuestion,
                                answers: [
                                  AppLocalizations.of(context)!.no,
                                  AppLocalizations.of(context)!.yes,
                                ],
                                onSelectionChanged: (value) =>
                                    updateAnswer(17, value)),
                            SubmitButton(
                                onPressed: submitForm,
                                buttonText:
                                    AppLocalizations.of(context)!.submit)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool areAllAnswersSelected(List<int> answers) {
    return !answers.contains(-1);
  }

  void submitForm() async {
    _formKey.currentState!.validate();
    if (_childAgeValidator && _motherAgeValidator) {
      _formKey.currentState!.save();
      updateAnswer(0, childAge);
      updateAnswer(2, motherAge);
      if (areAllAnswersSelected(answers)) {
        String? idEnfant = await storeService.getCurrentChildId();
        Questionnaire fromanswers =
            Questionnaire(childid: idEnfant!, questions: answers);

        storeService.createQuestionnaire(fromanswers);


        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        ShowDialog(
            context,
            AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.someFieldsAreMissing,
            false,
            const LoginScreen());
      }
    } else {
      ShowDialog(
          context,
          AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.someFieldsAreMissing,
          false,
          const LoginScreen());
    }
  }
}
