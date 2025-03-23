import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/constants/background.dart';
import 'package:flutter/material.dart';

import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../models/doctor.dart';
import '../services/firestore_service.dart';
import '../widgets/app_drawer.dart';
import 'doctor_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final FirestoreService _storeService = FirestoreService();
  List<Doctor> allDoctors = [];
  List<Doctor> displayedDoctors = [];
  TextEditingController searchController = TextEditingController();
  String filter = ''; // Search filter
  String selectedSpecialization = 'All'; // Default filter value

  @override
  void initState() {
    super.initState();
    fetchDoctorsFromFirestore();
    displayedDoctors = List.from(allDoctors);
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40.0, vertical: 40.0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.listOfDoctors,
                    style: bigTextstyle,
                  ),
                  const SizedBox(height: 30.0),
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
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filter = value.toLowerCase();
                          filterDoctors();
                        });
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 14.0),
                        prefixIcon: const Icon(
                          Icons.local_hospital,
                          color: Colors.white,
                        ),
                        hintText: AppLocalizations.of(context)!.searchDoctors,
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // Add filter options using a DropdownButton

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6CA8F1), // Background color
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: ListView.builder(
                        itemCount: displayedDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = displayedDoctors[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                              size: 40,
                            ),
                            title: Text(
                              "Dr.${displayedDoctors[index].name}",
                              style: smallTextstyle,
                            ),
                            subtitle: Text(
                              displayedDoctors[index].specialization,
                              style: radioTextstyle,
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailsScreen(uid: doctor.uid),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterDoctors() {
    List<Doctor> filteredList = allDoctors;

    if (filter.isNotEmpty) {
      filteredList = filteredList
          .where((doctor) =>
              doctor.name.toLowerCase().contains(filter) ||
              doctor.specialization.toLowerCase().contains(filter))
          .toList();
    }

    if (selectedSpecialization != 'All') {
      filteredList = filteredList
          .where((doctor) => doctor.specialization == selectedSpecialization)
          .toList();
    }

    setState(() {
      displayedDoctors = filteredList;
    });
  }

  Future<void> fetchDoctorsFromFirestore() async {
    try {
      List<Doctor> doctors = await _storeService.fetchDoctors();
      setState(() {
        allDoctors = doctors;

        displayedDoctors = List.from(allDoctors);
      });
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }
}
