import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/widgets/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../../main.dart';
import '../services/auth_service.dart';
import '../widgets/email_text_field.dart';
import '../widgets/password_text_field.dart';
import '../widgets/submit_button.dart';
import 'forget_password_screen.dart';
import 'home_screen.dart';
import 'language_screen.dart';
import 'register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService authService = FirebaseAuthService();

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  // bool _obscurePassword = true; // Initially, hide the password.
  bool _validateEmail = true;
  bool _validatePWD = true;
  // String? _validatePWDText = "";
  String selectedLang = '';
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
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LanguageScreen("login"),
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
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                )
                              ],
                            )),
                        const SizedBox(height: 60.0),
                        Text(
                          AppLocalizations.of(context)!.login,
                          style: bigTextstyle,
                        ),
                        const SizedBox(height: 30.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // _buildEmailTF(),
                              EmailTextField(
                                onValidationChanged: (isValid, email) {
                                  _validateEmail = isValid;
                                  _email = email;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              PasswordTextField(
                                onValidationChanged: (isValid, password) {
                                  _validatePWD = isValid;
                                  _password = password;
                                },
                              ),
                              // _buildPassWordTF(),
                              _buildForgotPasswordBtn(),
                              // _buildLoginBtn(),
                              SubmitButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _submitForm();
                                  },
                                  buttonText:
                                      AppLocalizations.of(context)!.login),
                            ],
                          ),
                        ),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    _formKey.currentState!.validate();
    if (_validateEmail && _validatePWD) {
      _formKey.currentState!.save();
      final User? userCredential =
          await authService.signInWithEmailAndPassword(_email, _password);
      if (userCredential != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        _showFaildDialog();
      }
      // After successful login, navigate to the next screen or perform other actions.
    }
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  // Widget _buildEmailTF() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         AppLocalizations.of(context)!.email,
  //         style: kLabelStyle,
  //       ),
  //       SizedBox(height: 10.0),
  //       Container(
  //           alignment: Alignment.centerLeft,
  //           decoration: BoxDecoration(
  //             color: Color(0xFF6CA8F1),
  //             borderRadius: BorderRadius.circular(10.0),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 blurRadius: 6.0,
  //                 offset: Offset(0, 2),
  //               ),
  //             ],
  //             border: Border.all(
  //               color: _validateEmail ? Colors.transparent : Colors.red,
  //               width: 2.0,
  //             ),
  //           ),
  //           height: 60.0,
  //           child: TextFormField(
  //             keyboardType: TextInputType.emailAddress,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontFamily: 'OpenSans',
  //             ),
  //             decoration: InputDecoration(
  //               border: InputBorder.none,
  //               contentPadding: EdgeInsets.only(top: 14.0),
  //               prefixIcon: Icon(
  //                 Icons.email,
  //                 color: _validateEmail
  //                     ? Colors.white
  //                     : Colors.red, // Change icon color to black
  //               ),
  //               hintText: AppLocalizations.of(context)!.emailhint,
  //               hintStyle: kHintTextStyle,
  //             ),
  //             validator: (value) {
  //               _validateEmailtext = validateEmail(value);
  //               if (_validateEmailtext != null) {
  //                 setState(() {
  //                   _validateEmail = false;
  //                 });
  //                 return null;
  //               } else {
  //                 setState(() {
  //                   _validateEmail = true;
  //                 });
  //                 return null;
  //               }
  //             },
  //             onSaved: (value) {
  //               _email = value!;
  //             },
  //           )),
  //       _validateEmail
  //           ? SizedBox(
  //               height: 0,
  //               width: 0,
  //             )
  //           : SizedBox(height: 10.0),
  //       _validateEmail
  //           ? SizedBox(
  //               height: 0,
  //               width: 0,
  //             )
  //           : Text(
  //               changeLang(_validateEmailtext!),
  //               style: TextStyle(color: Colors.red),
  //             ),
  //     ],
  //   );
  // }

  // Widget _buildPassWordTF() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         AppLocalizations.of(context)!.password,
  //         style: kLabelStyle,
  //       ),
  //       SizedBox(height: 10.0),
  //       Container(
  //         alignment: Alignment.centerLeft,
  //         decoration: BoxDecoration(
  //           color: Color(0xFF6CA8F1),
  //           borderRadius: BorderRadius.circular(10.0),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black12,
  //               blurRadius: 6.0,
  //               offset: Offset(0, 2),
  //             ),
  //           ],
  //           border: Border.all(
  //             color: _validatePWD ? Colors.transparent : Colors.red,
  //             width: 2.0,
  //           ),
  //         ),
  //         height: 60.0,
  //         child: TextFormField(
  //           obscureText: _obscurePassword,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontFamily: 'OpenSans',
  //           ),
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             contentPadding: EdgeInsets.only(top: 14.0),
  //             prefixIcon: Icon(
  //               Icons.lock,
  //               color: _validatePWD
  //                   ? Colors.white
  //                   : Colors.red, // Change icon color to black
  //             ),
  //             suffixIcon: IconButton(
  //               color: Color.fromARGB(255, 212, 233, 246),
  //               icon: Icon(
  //                 _obscurePassword ? Icons.visibility_off : Icons.visibility,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   _obscurePassword = !_obscurePassword;
  //                 });
  //               },
  //             ),
  //             hintText: AppLocalizations.of(context)!.passwordhint,
  //             hintStyle: kHintTextStyle,
  //           ),
  //           validator: (value) {
  //             _validatePWDText = validatePassword(value);
  //             if (_validatePWDText != null) {
  //               setState(() {
  //                 _validatePWD =
  //                     false; // Reset validation when user starts typing
  //               });
  //               return null;
  //             } else {
  //               setState(() {
  //                 _validatePWD =
  //                     true; // Reset validation when user starts typing
  //               });
  //               return null;
  //             }
  //           },
  //           onSaved: (value) {
  //             _password = value!;
  //           },
  //         ),
  //       ),
  //       _validatePWD
  //           ? SizedBox(
  //               height: 0,
  //               width: 0,
  //             )
  //           : SizedBox(height: 10.0),
  //       _validatePWD
  //           ? SizedBox(
  //               height: 0,
  //               width: 0,
  //             )
  //           : Text(
  //               changeLang(_validatePWDText!),
  //               style: TextStyle(color: Colors.red),
  //             ),
  //     ],
  //   );
  // }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _forgotPassword(),
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: kLabelStyle,
        ),
      ),
    );
  }

  // Widget _buildLoginBtn() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 25.0),
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         FocusScope.of(context).unfocus();
  //         _submitForm();
  //       },
  //       style: ElevatedButton.styleFrom(
  //         elevation: 5.0,
  //         padding: EdgeInsets.all(15.0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30.0),
  //         ),
  //         backgroundColor: Colors.white,
  //       ),
  //       child: Text(
  //         AppLocalizations.of(context)!.login,
  //         style: TextStyle(
  //           color: Color(0xFF527DAA),
  //           letterSpacing: 1.5,
  //           fontSize: 18.0,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'OpenSans',
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RegistrationScreen(),
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.dontHaveAccount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.createNewAccount,
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

  void _showFaildDialog() {
    ShowDialog(context, AppLocalizations.of(context)!.failed,
        AppLocalizations.of(context)!.loginFailed, false, const LoginScreen());
  }
}
