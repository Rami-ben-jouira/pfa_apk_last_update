import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/services/auth_service.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:adhd_helper/src/widgets/age_text_field.dart';
import 'package:adhd_helper/src/widgets/input_text_field.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../models/child.dart';
import 'home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateChildProfileScreen extends StatefulWidget {
  const CreateChildProfileScreen({super.key});

  @override
  State<CreateChildProfileScreen> createState() =>
      _CreateChildProfileScreenState();
}

class _CreateChildProfileScreenState extends State<CreateChildProfileScreen> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirestoreService storeService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  bool _nameValidater = true;
  int _age = 0;
  bool _ageValidater = true;
  String _gender = "";
  String _schoolLevel = "";
  bool _hasMedicalCondition = false;
  String _medicalCondition = '';
  String _medicationName = '';
  bool medicalConditionValidater = true;
  bool medicationNameValidater = true;

  @override
  Widget build(BuildContext context) {
    _gender = AppLocalizations.of(context)!.male;
    _schoolLevel = AppLocalizations.of(context)!.elementarySchool;
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
                        AppLocalizations.of(context)!.createChildProfile,
                        style: bigTextstyle,
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            InputTextField(
                                onValidationChanged: (isValid, input) {
                                  _nameValidater = isValid;
                                  _name = input;
                                },
                                inputText: AppLocalizations.of(context)!.name,
                                preficIcon: Icons.person),
                            AgeTextField(
                                onValidationChanged: (isValid, input) {
                                  _ageValidater = isValid;
                                  if (input == "") {
                                    _age = 0;
                                  } else {
                                    _age = int.tryParse(input)!;
                                  }
                                },
                                ageText: AppLocalizations.of(context)!.age,
                                preficIcon: Icons.calendar_today),
                            genderField(),
                            const SizedBox(height: 10.0),
                            schoolField(),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              height: 20.0,
                              child: Row(
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.white),
                                    child: Checkbox(
                                      value: _hasMedicalCondition,
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          _hasMedicalCondition = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .hasMedicalCondition,
                                    style: kLabelStyle,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if (_hasMedicalCondition)
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    medicalConditionValidater = isValid;
                                    _medicalCondition = input;
                                  },
                                  inputText: AppLocalizations.of(context)!
                                      .medicalCondition,
                                  preficIcon: Icons.local_hospital),
                            if (_hasMedicalCondition)
                              InputTextField(
                                  onValidationChanged: (isValid, input) {
                                    medicationNameValidater = isValid;
                                    _medicationName = input;
                                  },
                                  inputText: AppLocalizations.of(context)!
                                      .medicationName,
                                  preficIcon: Icons.local_hospital),
                            SubmitButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  saveChildProfil();
                                },
                                buttonText: AppLocalizations.of(context)!
                                    .createChildProfile),
                          ]))
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

  void saveChildProfil() {
    _formKey.currentState!.validate();
    if (_ageValidater && _nameValidater) {
      _formKey.currentState!.save();
      ChildProfil child = ChildProfil(
        parentUid: authService.getCurrentUser()!.uid,
        name: _name,
        age: _age,
        gender: _gender,
        schoolLevel: _schoolLevel,
        hasMedicalCondition: _hasMedicalCondition,
        medicalCondition: _medicalCondition,
        medicationName: _medicationName,
      );

      storeService.saveChildProfile(child.toMap());
      storeService.updateCurrentChildId(child.name);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  Widget genderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.gender,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
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
            border: Border.all(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: DropdownButtonFormField<String>(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            dropdownColor: const Color(0xFF6CA8F1),
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold),
            value: _gender,
            onChanged: (value) {
              setState(() {
                _gender = value!;
              });
            },
            items: [
              AppLocalizations.of(context)!.male,
              AppLocalizations.of(context)!.female
            ].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget schoolField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.schoolLevel,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
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
            border: Border.all(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: DropdownButtonFormField<String>(
            iconDisabledColor: Colors.white,
            iconEnabledColor: Colors.white,
            dropdownColor: const Color(0xFF6CA8F1),
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold),
            value: _schoolLevel,
            onChanged: (value) {
              setState(() {
                _schoolLevel = value!;
              });
            },
            items: [
              AppLocalizations.of(context)!.elementarySchool,
              AppLocalizations.of(context)!.middleSchool,
              AppLocalizations.of(context)!.highSchool
            ].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.school,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



// SizedBox(height: 20.0),
//                       Text(
//                         AppLocalizations.of(context)!.profile,
//                         style: bigTextstyle,
//                       ),
//                       SizedBox(height: 30.0),
//                       Form(
//                         key: _formKey,
//                         child: ListView(
//                           padding: EdgeInsets.all(16),
//                           children: [
//                             TextFormField(
//                               decoration: InputDecoration(
//                                   labelText:
//                                       AppLocalizations.of(context)!.name),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return AppLocalizations.of(context)!
//                                       .enterName;
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _name = value!;
//                               },
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                   labelText: AppLocalizations.of(context)!.age),
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return AppLocalizations.of(context)!.enterAge;
//                                 }
//                                 if (int.tryParse(value)! < 3 ||
//                                     int.tryParse(value)! > 18) {
//                                   return AppLocalizations.of(context)!.ageRange;
//                                 }
//                                 return null;
//                               },
//                               onSaved: (value) {
//                                 _age = int.tryParse(value!)!;
//                               },
//                             ),
//                             DropdownButtonFormField<String>(
//                               value: _gender,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _gender = value!;
//                                 });
//                               },
//                               items: [
//                                 AppLocalizations.of(context)!.male,
//                                 AppLocalizations.of(context)!.female
//                               ].map<DropdownMenuItem<String>>(
//                                 (String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 },
//                               ).toList(),
//                               decoration: InputDecoration(
//                                   labelText:
//                                       AppLocalizations.of(context)!.gender),
//                             ),
//                             DropdownButtonFormField<String>(
//                               value: _schoolLevel,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _schoolLevel = value!;
//                                 });
//                               },
//                               items: [
//                                 AppLocalizations.of(context)!.elementarySchool,
//                                 AppLocalizations.of(context)!.middleSchool,
//                                 AppLocalizations.of(context)!.highSchool
//                               ].map<DropdownMenuItem<String>>(
//                                 (String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(value),
//                                   );
//                                 },
//                               ).toList(),
//                               decoration: InputDecoration(
//                                   labelText: AppLocalizations.of(context)!
//                                       .schoolLevel),
//                             ),
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: _hasMedicalCondition,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _hasMedicalCondition = value!;
//                                     });
//                                   },
//                                 ),
//                                 Text(AppLocalizations.of(context)!
//                                     .hasMedicalCondition),
//                               ],
//                             ),
//                             if (_hasMedicalCondition)
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                     labelText: AppLocalizations.of(context)!
//                                         .medicalCondition),
//                                 onSaved: (value) {
//                                   _medicalCondition = value!;
//                                 },
//                               ),
//                             if (_hasMedicalCondition)
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                     labelText: AppLocalizations.of(context)!
//                                         .medicationName),
//                                 onSaved: (value) {
//                                   _medicationName = value!;
//                                 },
//                               ),
//                             SizedBox(height: 20),
//                             ElevatedButton(
//                               onPressed: () {
//                                 saveChildProfil();
//                               },
//                               child: Text(AppLocalizations.of(context)!
//                                   .createChildProfile),
//                             ),
//                           ],
//                         ),
//                       ),
