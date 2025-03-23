import 'package:adhd_helper/src/screens/child_selection_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/textstyle.dart';
import '../screens/doctor_details_screen.dart';
import '../screens/home_screen.dart';
import '../screens/kids_mode_screens/kids_home_screen.dart';
import '../screens/language_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService authService = FirebaseAuthService();

    final FirestoreService storeService = FirestoreService();

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 95, 179, 245),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(255, 125, 192, 246),
          //   ),
          //   child: FutureBuilder<UserProfile?>(
          //     future: _storeService.getProfileByuid(
          //         _authService.getCurrentUser()!.uid), // Pass the Future here.
          //     builder:
          //         (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
          //       // The builder function gets called whenever the Future's status changes.
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         // While waiting for the Future to complete, you can show a loading indicator.
          //         return SizedBox(height: 0, width: 0);
          //       } else if (snapshot.hasError) {
          //         // If there was an error during the Future execution, handle it here.
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         // When the Future completes successfully, you can access its result.
          //         return Text(
          //           AppLocalizations.of(context)!.hi +
          //               " " +
          //               snapshot.data!.firstName,
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 24,
          //           ),
          //         );
          //       }
          //     },
          //   ),
          // ),
          const SizedBox(
            height: 50.0,
          ),
          const Text("  ADHD Helper", style: bigTextstyle),
          const Divider(
            color: Colors.white,
          ), // Add a horizontal line (divider)

          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
              size: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.homePage,
              style: drawerTextstyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.white,
              size: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.profile,
              style: drawerTextstyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          FutureBuilder<String?>(
            future: storeService.getDoctorUidFromUser(
              authService.getCurrentUser()!.uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 0, width: 0);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListTile(
                  leading: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 25,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.doctor,
                    style: drawerTextstyle,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailsScreen(uid: snapshot.data!),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox(width: 0, height: 0);
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.public,
              color: Colors.white,
              size: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: drawerTextstyle,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LanguageScreen("home"),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.abc,
              color: Colors.white,
              size: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.kidsMode,
              style: drawerTextstyle,
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const KidsHomeScreen(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.child_care,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          //   title: Text(
          //     "cureent child",
          //     style: drawerTextstyle,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) => const ChildSelectionScreen(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 25,
            ),
            title: Text(
              AppLocalizations.of(context)!.logOut,
              style: drawerTextstyle,
            ),
            onTap: () async {
              await authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
