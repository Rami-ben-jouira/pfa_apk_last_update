import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/doctors_list_screen.dart';
import 'package:adhd_helper/src/widgets/submit_button.dart';
import 'package:adhd_helper/src/widgets/submit_button_style.dart';
import 'package:flutter/material.dart';

import '../../constants/textstyle.dart';
import '../models/doctor.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_drawer.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String uid;

  const DoctorDetailsScreen({super.key, required this.uid});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _storeService = FirestoreService();
  bool doctorselected = false;
  String? doctorUid;
  @override
  void initState() {
    doctorselection();
    super.initState();
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
            child: FutureBuilder<Doctor?>(
                future: _storeService.getDoctorbyUId(widget.uid),
                builder: (context, AsyncSnapshot<Doctor?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 0,
                      width: 0,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Doctor doctor = snapshot.data!;

                    if (doctor.uid == doctorUid) {
                      doctorselected = true;
                    }

                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!.doctorTitle +
                                doctor.name,
                            style: bigTextstyle,
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6CA8F1),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .doctorspecialization,
                                        style: smallTextstyle,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .doctoraddress,
                                        style: smallTextstyle,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .doctorphone,
                                        style: smallTextstyle,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .doctoremail,
                                        style: smallTextstyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.specialization,
                                        style: smallTextstylenobold,
                                      ),
                                      Text(
                                        doctor.address,
                                        style: smallTextstylenobold,
                                      ),
                                      Text(
                                        doctor.phone_number,
                                        style: smallTextstylenobold,
                                      ),
                                      Text(
                                        doctor.email,
                                        style: smallTextstylenobold,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              SubmitButtonStyle(
                                  onPressed: () {
                                    if (doctorselected) {
                                      null;
                                    } else {
                                      _storeService
                                          .saveDoctorUidInUserProfilAndUserProfilInDoctorProfil(
                                              _authService
                                                  .getCurrentUser()!
                                                  .uid,
                                              doctor.uid);
                                      setState(() {
                                        doctorselected = true;
                                      });
                                    }
                                  },
                                  buttonText: doctorselected
                                      ? AppLocalizations.of(context)!
                                          .doctorSelected
                                      : AppLocalizations.of(context)!
                                          .selectDoctor,
                                  color: doctorselected
                                      ? Colors.grey
                                      : Colors.white),
                              if (doctorselected)
                                Container(
                                  height: 70,
                                  color: Colors.transparent,
                                ),
                            ],
                          ),
                          SubmitButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const DoctorsScreen(),
                                  ),
                                );
                              },
                              buttonText:
                                  AppLocalizations.of(context)!.changeDoctor),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Future<void> doctorselection() async {
    try {
      doctorUid = await _storeService
          .getDoctorUidFromUser(_authService.getCurrentUser()!.uid);
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }
}
