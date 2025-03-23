import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/login_screen.dart';
import 'package:adhd_helper/src/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'package:adhd_helper/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/appbar.dart';
import '../../constants/textstyle.dart';
import 'home_screen.dart';

class LanguageScreen extends StatefulWidget {
  final String pagename;
  const LanguageScreen(this.pagename, {super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedOption = 'English';
  var returnpage;
  @override
  void initState() {
    super.initState();
    MyApp.getLocale().then((locale) {
      if (locale == const Locale("en")) {
        setState(() {
          selectedOption = "English";
        });
      } else if (locale == const Locale("fr")) {
        setState(() {
          selectedOption = "Français";
        });
      } else if (locale == const Locale("ar")) {
        setState(() {
          selectedOption = "العربية";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          background,
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
            child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.selectYourLanguage,
                        style: midTextstyle),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildLanguageTile(
                              AppLocalizations.of(context)!.english, "en"),
                          buildLanguageTile(
                              AppLocalizations.of(context)!.french, "fr"),
                          buildLanguageTile(
                              AppLocalizations.of(context)!.arabic, "ar"),
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
    );
  }

  Widget buildLanguageTile(String language, String lang) {
    return ListTile(
      title: Text(
        language,
        style: smallTextstyle,
      ),
      trailing: Radio(
        activeColor: Colors.white,
        value: language,
        groupValue: selectedOption,
        onChanged: (value) {
          MyApp.setLocale(context, Locale(lang.toString(), ""));
          if (lang == "en") {
            setState(() {
              selectedOption = "English";
              _changePage();
            });
          } else if (lang == "fr") {
            setState(() {
              selectedOption = "Français";
              _changePage();
            });
          } else if (lang == "ar") {
            setState(() {
              selectedOption = "العربية";
              _changePage();
            });
          }
        },
      ),
      onTap: () {
        MyApp.setLocale(context, Locale(lang.toString(), ""));
        if (lang == "en") {
          setState(() {
            selectedOption = "English";
            _changePage();
          });
        } else if (lang == "fr") {
          setState(() {
            selectedOption = "Français";
            _changePage();
          });
        } else if (lang == "ar") {
          setState(() {
            selectedOption = "العربية";
            _changePage();
          });
        }
      },
    );
  }

  void _changePage() {
    if (widget.pagename == "login") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      if (widget.pagename == "register") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RegistrationScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }
}
