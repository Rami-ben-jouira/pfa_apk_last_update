// Load the saved value from SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loadSavedValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool kidsmode = prefs.getBool('kidsmode') ?? false;
  return kidsmode; // Use a default value if it doesn't exist
}

// Save the variable's value to SharedPreferences
saveValue(kidsmode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('kidsmode', kidsmode);
}
