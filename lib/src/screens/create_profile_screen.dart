import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/services/auth_service.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:adhd_helper/src/widgets/input_text_field.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:adhd_helper/src/models/user.dart';

import '../../constants/appbar.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../widgets/phone_text_filed.dart';
import 'create_child_profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirestoreService storeService = FirestoreService();

  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _number = '';
  bool _firstNameValidater = true;
  bool _lastNameValidater = true;
  bool _numberValidater = true;
  bool _addSpouse = false;
  String _spouseFirstName = '';
  String _spouseLastName = '';
  String _spouseNumber = '';
  String _spouseEmail = '';
  bool _spouseFirstNameValidater = true;
  bool _spouseLastNameValidater = true;
  bool _spouseNumberValidater = true;
  bool _spouseEmailValidater = true;

  @override
  Widget build(BuildContext context) {
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
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Text(
                        AppLocalizations.of(context)!.profile,
                        style: bigTextstyle,
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            InputTextField(
                                onValidationChanged: (isValid, input) {
                                  _firstNameValidater = isValid;
                                  _firstName = input;
                                },
                                inputText:
                                    AppLocalizations.of(context)!.firstName,
                                preficIcon: Icons.person),
                            InputTextField(
                                onValidationChanged: (isValid, input) {
                                  _lastNameValidater = isValid;
                                  _lastName = input;
                                },
                                inputText:
                                    AppLocalizations.of(context)!.lastName,
                                preficIcon: Icons.person),
                            PhoneTextField(
                                onValidationChanged: (isValid, input) {
                                  _numberValidater = isValid;
                                  _number = input;
                                },
                                inputText:
                                    AppLocalizations.of(context)!.phoneNumber,
                                preficIcon: Icons.phone),
                            SizedBox(
                              height: 20.0,
                              child: Row(
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.white),
                                    child: Checkbox(
                                      value: _addSpouse,
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          _addSpouse = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.addSpouse,
                                    style: kLabelStyle,
                                  ),
                                ],
                              ),
                            ),
                            if (_addSpouse) ...[
                              // Additional fields for spouse information.
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    _spouseFirstNameValidater = isValid;
                                    _spouseFirstName = input;
                                  },
                                  inputText: AppLocalizations.of(context)!
                                      .spouseFirstName,
                                  preficIcon: Icons.person),
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    _spouseLastNameValidater = isValid;
                                    _spouseLastName = input;
                                  },
                                  inputText: AppLocalizations.of(context)!
                                      .spouseLastName,
                                  preficIcon: Icons.person),
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    _spouseNumberValidater = isValid;
                                    _spouseNumber = input;
                                  },
                                  inputText: AppLocalizations.of(context)!
                                      .spousePhoneNumber,
                                  preficIcon: Icons.phone),
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    _spouseEmailValidater = isValid;
                                    _spouseEmail = input;
                                  },
                                  inputText:
                                      AppLocalizations.of(context)!.spouseEmail,
                                  preficIcon: Icons.email),
                            ],
                            SubmitButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _submitForm();
                                },
                                buttonText:
                                    AppLocalizations.of(context)!.createProfile)
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

  void _submitForm() {
    _formKey.currentState!.validate();

    if (_firstNameValidater && _lastNameValidater && _numberValidater) {
      UserProfile userProfile;
      if (_addSpouse) {
        if (_spouseEmailValidater &&
            _spouseFirstNameValidater &&
            _spouseLastNameValidater &&
            _spouseNumberValidater) {
          _formKey.currentState!.save();

          userProfile = UserProfile(
            uid: authService
                .getCurrentUser()!
                .uid, 
            email: authService.getCurrentUser()!.email,
            firstName: _firstName,
            lastName: _lastName,
            number: _number,
            spouse: _addSpouse,
            spouseFirstName: _spouseFirstName,
            spouseLastName: _spouseLastName,
            spouseNumber: _spouseNumber,
            spouseEmail: _spouseEmail,
            doctorUid: null,
          );
          storeService.saveUserProfile(userProfile.toMap());
        }
      } else {
        _formKey.currentState!.save();
        userProfile = UserProfile(
          uid:
              authService.getCurrentUser()!.uid, // Replace with the user's UID.
          email: authService.getCurrentUser()!.email,
          firstName: _firstName,
          lastName: _lastName,
          number: _number,
          spouse: _addSpouse,
          spouseFirstName: null,
          spouseLastName: null,
          spouseNumber: null,
          spouseEmail: null,
          doctorUid: null,
        );
        storeService.saveUserProfile(userProfile.toMap());
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CreateChildProfileScreen(),
        ),
      );
    }
  }
}
