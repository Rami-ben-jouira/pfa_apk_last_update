import 'package:shared_preferences/shared_preferences.dart';

Future<String> loadLangValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lang = prefs.getString('language')?? "Anglais";
  return lang; // Use a default value if it doesn't exist
}

// Save the variable's value to SharedPreferences
saveLang(lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('language', lang);
  
}
