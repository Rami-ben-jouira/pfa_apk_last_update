import 'package:adhd_helper/src/screens/create_profile_screen.dart';
import 'package:adhd_helper/src/screens/language_screen.dart';
import 'package:adhd_helper/src/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/background.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../../main.dart';
import '../../utils/validators.dart';
import '../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuthService authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true; // Initially, hide the password.
  bool _obscureConfirmPassword = true;
  String selectedLang = '';
  bool _validateEmail = true;
  String? _validateEmailtext = "";
  bool _validatePWD = true;
  String? _validatePWDText = "";
  bool _validateConfPWD = true;

  @override
  void initState() {
    super.initState();
    MyApp.getLocale().then((locale) {
      if (locale == const Locale("en")) {
        setState(() {
          selectedLang = "English ";
        });
      } else if (locale == const Locale("fr")) {
        setState(() {
          selectedLang = "Français ";
        });
      } else if (locale == const Locale("ar")) {
        setState(() {
          selectedLang = "العربية";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
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
                        _buildlanguage(),
                        const SizedBox(height: 60.0),
                        Text(
                          AppLocalizations.of(context)!.register,
                          style: bigTextstyle,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildEmailTF(),
                              const SizedBox(height: 20.0),
                              _buildPassWordTF(),
                              const SizedBox(height: 20.0),
                              _buildConfirmPassWordTF(),
                              _buildRegisterBtn()
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSignInBtn()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    _formKey.currentState!.validate();

    if (_validateEmail && _validatePWD && _validateConfPWD) {
      _formKey.currentState!.save();
      await authService.registerWithEmailAndPassword(_email, _password);
      final User? user =
          await authService.signInWithEmailAndPassword(_email, _password);
      authService.sendVerificationEmail();
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CreateProfileScreen(),
          ),
        );
      }
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.email,
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
                color: _validateEmail ? Colors.transparent : Colors.red,
                width: 2.0,
              ),
            ),
            height: 60.0,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: _validateEmail
                      ? Colors.white
                      : Colors.red, // Change icon color to black
                ),
                hintText: AppLocalizations.of(context)!.emailhint,
                hintStyle: kHintTextStyle,
              ),
              validator: (value) {
                _validateEmailtext = validateEmail(value);
                if (_validateEmailtext != null) {
                  setState(() {
                    _validateEmail =
                        false; // Reset validation when user starts typing
                  });
                  return null;
                } else {
                  setState(() {
                    _validateEmail =
                        true; // Reset validation when user starts typing
                  });
                  return null;
                }
              },
              onSaved: (value) {
                _email = value!;
              },
            )),
        _validateEmail
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : const SizedBox(height: 10.0),
        _validateEmail
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Text(
                changeLang(_validateEmailtext!),
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  Widget _buildPassWordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.password,
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
              color: _validatePWD ? Colors.transparent : Colors.red,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: TextFormField(
            obscureText: _obscurePassword,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: _validatePWD
                    ? Colors.white
                    : Colors.red, // Change icon color to black
              ),
              suffixIcon: IconButton(
                color: const Color.fromARGB(255, 212, 233, 246),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              hintText: AppLocalizations.of(context)!.passwordhint,
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              _validatePWDText = validatePassword(value);
              if (_validatePWDText != null) {
                setState(() {
                  _validatePWD =
                      false; // Reset validation when user starts typing
                });
                return null;
              } else {
                setState(() {
                  _validatePWD =
                      true; // Reset validation when user starts typing
                });
                _password = value!;
                return null;
              }
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
        ),
        _validatePWD
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : const SizedBox(height: 10.0),
        _validatePWD
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Text(
                changeLang(_validatePWDText!),
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  Widget _buildConfirmPassWordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.confirmPassword,
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
              color: _validateConfPWD ? Colors.transparent : Colors.red,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: TextFormField(
            obscureText: _obscureConfirmPassword,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: _validateConfPWD
                    ? Colors.white
                    : Colors.red, // Change icon color to black
              ),
              suffixIcon: IconButton(
                color: const Color.fromARGB(255, 212, 233, 246),
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              hintText: AppLocalizations.of(context)!.passwordhint,
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value != _password) {
                setState(() {
                  _validateConfPWD =
                      false; // Reset validation when user starts typing
                });
                return null;
              } else {
                setState(() {
                  _validateConfPWD =
                      true; // Reset validation when user starts typing
                });
                return null;
              }
            },
          ),
        ),
        _validateConfPWD
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : const SizedBox(height: 10.0),
        _validateConfPWD
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Text(
                AppLocalizations.of(context)!.passwordsDoNotMatch,
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          _submitForm();
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          AppLocalizations.of(context)!.register,
          style: const TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                const LoginScreen(), // Create a RegistrationScreen class
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.alreadyHaveAccount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.login,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildlanguage() {
    return TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LanguageScreen("register"),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, color: Colors.white),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              selectedLang,
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            )
          ],
        ));
  }

  String changeLang(String message) {
    if (message == "Email is required") {
      return AppLocalizations.of(context)!.emailIsRequired;
    } else if (message == "Invalid email address") {
      return AppLocalizations.of(context)!.invalidEmailAddress;
    } else if (message == "Password is required") {
      return AppLocalizations.of(context)!.passwordIsRequired;
    } else if (message == "Password must be at least 6 characters long") {
      return AppLocalizations.of(context)!.passwordLengthRequirement;
    }
    return "";
  }
}
