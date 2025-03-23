import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/widgets/app_drawer.dart';
import 'package:adhd_helper/src/widgets/input_text_field_controller.dart';
import 'package:adhd_helper/src/widgets/phone_text_field_controller.dart';
import 'package:flutter/material.dart';
import '../../constants/appbar.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/input_text_field.dart';
import '../widgets/submit_button.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _number = '';
  bool _addSpouse = false;
  String _spouseFirstName = '';
  String _spouseLastName = '';
  String _spouseEmail = '';
  String _spouseNumber = '';
  bool _firstNameValidater = true;
  bool _lastNameValidater = true;
  bool _numberValidater = true;
  bool spouseFirstNameValidater = true;
  bool spouseLastNameValidater = true;
  bool spouseNumberValidater = true;
  bool spouseEmailValidater = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
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
                        AppLocalizations.of(context)!.profile,
                        style: bigTextstyle,
                      ),
                      FutureBuilder<UserProfile?>(
                        future: _firestoreService.getProfileByuid(
                            _authService.getCurrentUser()!.uid),
                        builder:
                            (context, AsyncSnapshot<UserProfile?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          } else if (snapshot.hasError) {
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          } else {
                            UserProfile userProfile = snapshot.data!;

                            TextEditingController firstNameController =
                                TextEditingController(
                                    text: userProfile.firstName);
                            TextEditingController lastNameController =
                                TextEditingController(
                                    text: userProfile.lastName);
                            TextEditingController numberController =
                                TextEditingController(text: userProfile.number);
                            bool spouseprofil = userProfile.spouse;
                            TextEditingController spousefirstNameController =
                                TextEditingController(
                                    text: userProfile.spouseFirstName);
                            TextEditingController spouselastNameController =
                                TextEditingController(
                                    text: userProfile.spouseLastName);
                            TextEditingController spousenumberController =
                                TextEditingController(
                                    text: userProfile.spouseNumber);
                            TextEditingController spouseemailController =
                                TextEditingController(
                                    text: userProfile.spouseEmail);
                            return Form(
                                key: _formKey,
                                child: Column(children: <Widget>[
                                  InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        _firstNameValidater = isValid;
                                        _firstName = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .firstName,
                                      preficIcon: Icons.person,
                                      controller: firstNameController),
                                  InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        _lastNameValidater = isValid;
                                        _lastName = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .lastName,
                                      preficIcon: Icons.person,
                                      controller: lastNameController),
                                  PhoneTextFieldController(
                                    onValidationChanged: (isValid, input) {
                                      _numberValidater = isValid;
                                      _number = input;
                                    },
                                    inputText: AppLocalizations.of(context)!
                                        .phoneNumber,
                                    preficIcon: Icons.phone,
                                    controller: numberController,
                                  ),
                                  if (spouseprofil) ...[
                                    // Additional fields for spouse information.
                                    InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        spouseFirstNameValidater = isValid;
                                        _spouseFirstName = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .spouseFirstName,
                                      preficIcon: Icons.person,
                                      controller: spousefirstNameController,
                                    ),
                                    InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        spouseLastNameValidater = isValid;
                                        _spouseLastName = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .spouseLastName,
                                      preficIcon: Icons.person,
                                      controller: spouselastNameController,
                                    ),
                                    InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        spouseNumberValidater = isValid;
                                        _spouseNumber = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .spousePhoneNumber,
                                      preficIcon: Icons.phone,
                                      controller: spousenumberController,
                                    ),
                                    InputTextFieldController(
                                      onValidationChanged: (isValid, input) {
                                        spouseEmailValidater = isValid;
                                        _spouseEmail = input;
                                      },
                                      inputText: AppLocalizations.of(context)!
                                          .spouseEmail,
                                      preficIcon: Icons.email,
                                      controller: spouseemailController,
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      height: 20.0,
                                      child: Row(
                                        children: <Widget>[
                                          Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.white),
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
                                            AppLocalizations.of(context)!
                                                .addSpouse,
                                            style: kLabelStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    if (_addSpouse) ...[
                                      // Additional fields for spouse information.
                                      InputTextField(
                                          onValidationChanged:
                                              (isValid, input) {
                                            spouseFirstNameValidater = isValid;
                                            _spouseFirstName = input;
                                          },
                                          inputText:
                                              AppLocalizations.of(context)!
                                                  .spouseFirstName,
                                          preficIcon: Icons.person),
                                      InputTextField(
                                          onValidationChanged:
                                              (isValid, input) {
                                            spouseLastNameValidater = isValid;
                                            _spouseLastName = input;
                                          },
                                          inputText:
                                              AppLocalizations.of(context)!
                                                  .spouseLastName,
                                          preficIcon: Icons.person),
                                      InputTextField(
                                          onValidationChanged:
                                              (isValid, input) {
                                            spouseNumberValidater = isValid;
                                            _spouseNumber = input;
                                          },
                                          inputText:
                                              AppLocalizations.of(context)!
                                                  .spousePhoneNumber,
                                          preficIcon: Icons.phone),
                                      InputTextField(
                                          onValidationChanged:
                                              (isValid, input) {
                                            spouseEmailValidater = isValid;
                                            _spouseEmail = input;
                                          },
                                          inputText:
                                              AppLocalizations.of(context)!
                                                  .spouseEmail,
                                          preficIcon: Icons.email),
                                    ],
                                  ],
                                  SubmitButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        updateprofile(userProfile);
                                      },
                                      buttonText: AppLocalizations.of(context)!
                                          .updateProfile)
                                ]));
                          }
                        },
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

  void updateprofile(UserProfile userProfile) {
    _formKey.currentState!.validate();
    if (_firstNameValidater && _lastNameValidater && _numberValidater) {
      _formKey.currentState!.save();
      userProfile.firstName = _firstName;
      userProfile.lastName = _lastName;
      userProfile.number = _number;
      if (userProfile.spouse) {
        userProfile.spouseFirstName = _spouseFirstName;
        userProfile.spouseLastName = _spouseLastName;
        userProfile.spouseNumber = _spouseNumber;
        userProfile.spouseEmail = _spouseEmail;
      }
      if (_addSpouse) {
        userProfile.spouse = _addSpouse;
        userProfile.spouseFirstName = _spouseFirstName;
        userProfile.spouseLastName = _spouseLastName;
        userProfile.spouseNumber = _spouseNumber;
        userProfile.spouseEmail = _spouseEmail;
      }
      _firestoreService.updateProfileByUid(
          userProfile.uid, userProfile.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
// InputTextFieldController(
//                                 onValidationChanged: (isValid, input) {
//                                   var _firstNameValidater = isValid;
//                                   _firstName = input;
//                                 },
//                                 inputText:
//                                     AppLocalizations.of(context)!.firstName,
//                                 preficIcon: Icons.person,
//                                 controller: firstNameController),
//                             InputTextFieldController(
//                                 onValidationChanged: (isValid, input) {
//                                   var _lastNameValidater = isValid;
//                                   _lastName = input;
//                                 },
//                                 inputText:
//                                     AppLocalizations.of(context)!.lastName,
//                                 preficIcon: Icons.person,controller: lastNameController),
//                             PhoneTextFieldController(
//                                 onValidationChanged: (isValid, input) {
//                                   _numberValidater = isValid;
//                                   _number = input;
//                                 },
//                                 inputText:
//                                     AppLocalizations.of(context)!.phoneNumber,
//                                 preficIcon: Icons.phone),
//                             Container(
//                               height: 20.0,
//                               child: Row(
//                                 children: <Widget>[
//                                   Theme(
//                                     data: ThemeData(
//                                         unselectedWidgetColor: Colors.white),
//                                     child: Checkbox(
//                                       value: _addSpouse,
//                                       checkColor: Colors.green,
//                                       activeColor: Colors.white,
//                                       onChanged: (value) {
//                                         setState(() {
//                                           _addSpouse = value!;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   Text(
//                                     AppLocalizations.of(context)!.addSpouse,
//                                     style: kLabelStyle,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             if (_addSpouse) ...[
//                               // Additional fields for spouse information.
//                               InputTextField(
//                                   onValidationChanged: (isValid, input) {
//                                     spouseFirstNameValidater = isValid;
//                                     _spouseFirstName = input;
//                                   },
//                                   inputText: AppLocalizations.of(context)!
//                                       .spouseFirstName,
//                                   preficIcon: Icons.person),
//                               InputTextField(
//                                   onValidationChanged: (isValid, input) {
//                                     spouseLastNameValidater = isValid;
//                                     _spouseLastName = input;
//                                   },
//                                   inputText: AppLocalizations.of(context)!
//                                       .spouseLastName,
//                                   preficIcon: Icons.person),
//                               InputTextField(
//                                   onValidationChanged: (isValid, input) {
//                                     spouseNumberValidater = isValid;
//                                     _spouseNumber = input;
//                                   },
//                                   inputText: AppLocalizations.of(context)!
//                                       .spousePhoneNumber,
//                                   preficIcon: Icons.phone),
//                               InputTextField(
//                                   onValidationChanged: (isValid, input) {
//                                     spouseEmailValidater = isValid;
//                                     _spouseEmail = input;
//                                   },
//                                   inputText:
//                                       AppLocalizations.of(context)!.spouseEmail,
//                                   preficIcon: Icons.email),
//                             ],