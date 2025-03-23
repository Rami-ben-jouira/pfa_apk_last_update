import 'package:adhd_helper/src/models/activites.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:adhd_helper/constants/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RoutineQuotidiennesScreen extends StatefulWidget {
  @override
  State<RoutineQuotidiennesScreen> createState() =>
      _RoutineQuotidiennesScreenState();
}

class _RoutineQuotidiennesScreenState extends State<RoutineQuotidiennesScreen> {
  final FirestoreService _storeService = FirestoreService();
  List<String> selectedActivities = [];

  @override
  void initState() {
    super.initState();
    _fetchSelectedActivities();
  }

  Future<void> _fetchSelectedActivities() async {
    String? idEnfant = await _storeService.getCurrentChildId();
    if (idEnfant != null) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Activites_comportementales')
          .where('childId', isEqualTo: idEnfant)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();

      setState(() {
        selectedActivities =
            snapshot.docs.map((doc) => doc['activite'] as String).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Morning Routine Section
                Text(
                  AppLocalizations.of(context)!
                      .morningRoutine, // Translated text
                  style:
                      bigTextstyle, // Use the same text style as in KidsHomeScreen
                ),
                const SizedBox(height: 16.0),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  children: [
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .makeBed, // Translated text
                      time: '7:00 AM',
                      image: 'assets/images/lit.png',
                      Matin: true,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .makeBed), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .goToBathroom, // Translated text
                      time: '7:20 AM',
                      image: 'assets/images/toilet.png',
                      Matin: true,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .goToBathroom), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .haveBreakfast, // Translated text
                      time: '7:30 AM',
                      image: 'assets/images/table.png',
                      Matin: true,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .haveBreakfast), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .getDressed, // Translated text
                      time: '7:50 AM',
                      image: 'assets/images/fg.png',
                      Matin: true,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .getDressed), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .prepareForSchool, // Translated text
                      time: '8:00 AM',
                      image: 'assets/images/ecole.png',
                      Matin: true,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .prepareForSchool), // Translated text
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Evening Routine Section
                Text(
                  AppLocalizations.of(context)!
                      .eveningRoutine, // Translated text
                  style:
                      bigTextstyle, // Use the same text style as in KidsHomeScreen
                ),
                const SizedBox(height: 16.0),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  children: [
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .doHomework, // Translated text
                      time: '17:00 PM',
                      image: 'assets/images/tb.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .doHomework), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .playTidyRoom, // Translated text
                      time: '17:30 PM',
                      image: 'assets/images/jouets.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .playTidyRoom), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .takeBath, // Translated text
                      time: '17:50 PM',
                      image: 'assets/images/do.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .takeBath), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .haveDinner, // Translated text
                      time: '20:00 PM',
                      image: 'assets/images/diner.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .haveDinner), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .brushTeeth, // Translated text
                      time: '20:30 PM',
                      image: 'assets/images/dent.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .brushTeeth), // Translated text
                    ),
                    RoutineActivityItem(
                      activity: AppLocalizations.of(context)!
                          .goToSleep, // Translated text
                      time: '20:40 PM',
                      image: 'assets/images/lit.png',
                      Matin: false,
                      isSelected: selectedActivities.contains(
                          AppLocalizations.of(context)!
                              .goToSleep), // Translated text
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoutineActivityItem extends StatefulWidget {
  final String activity;
  final String time;
  final String image;
  final bool Matin;
  final bool isSelected; // Indicates if the activity is already selected

  RoutineActivityItem({
    required this.activity,
    required this.time,
    required this.image,
    required this.Matin,
    this.isSelected = false, // Default to false
  });

  @override
  _RoutineActivityItemState createState() => _RoutineActivityItemState();
}

class _RoutineActivityItemState extends State<RoutineActivityItem> {
  bool isExpanded = false;
  final FirestoreService _storeService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Initialize isExpanded based on isSelected
    isExpanded = widget.isSelected;
  }

  @override
  void didUpdateWidget(RoutineActivityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update isExpanded when isSelected changes
    if (widget.isSelected != oldWidget.isSelected) {
      setState(() {
        isExpanded = widget.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isSelected) {
          setState(() {
            isExpanded = !isExpanded;
            if (isExpanded) {
              if (widget.Matin) {
                _saveActivityToFirestore(
                    'في صباح', widget.activity, widget.time);
              } else {
                _saveActivityToFirestore(
                    'في مساء', widget.activity, widget.time);
              }
            }
          });
        }
      },
      child: Card(
        elevation: 5.0,
        color: isExpanded
            ? Colors.blue
            : Colors.white, // Apply blue color if expanded or selected
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? 200 : 100,
          height: isExpanded ? 200 : 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.image,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.activity,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isExpanded
                        ? Colors.white
                        : Colors
                            .black, // Change text color for better visibility
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.time,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: isExpanded
                        ? Colors.white
                        : Colors
                            .grey, // Change text color for better visibility
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveActivityToFirestore(
      String section, String activite, String time) async {
    String? idEnfant = await _storeService.getCurrentChildId();
    Activites activites = Activites(
        childId: idEnfant!,
        section: section,
        activite: activite,
        timestamp: FieldValue.serverTimestamp());

    _storeService.addActivite(activites);
  }
}
