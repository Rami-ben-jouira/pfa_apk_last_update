import 'package:adhd_helper/constants/background.dart';
import 'package:adhd_helper/src/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/contanat.dart';
import '../../constants/textstyle.dart';
import '../../utils/validators.dart';
import '../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/show_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuthService authService = FirebaseAuthService();
  bool _validateEmail = true;
  String? _validateEmailtext = "";

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.resetPassword,
                        style: bigTextstyle,
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _buildEmailTF(),
                            _buildResetPasswordBtn(),
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
      ),
    );
  }

  void _showConfirmationDialog(bool sending) {
    if (sending) {
      ShowDialog(
          context,
          AppLocalizations.of(context)!.done,
          AppLocalizations.of(context)!.resetEmailInstructions,
          true,
          const LoginScreen());
    } else {
      ShowDialog(context, AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.errorResetEmail, false, const LoginScreen());
    }
  }

  void sendmassage() async {
    _formKey.currentState!.validate();
    if (_validateEmail) {
      bool sending =
          await authService.sendPasswordResetEmail(_emailController.text);
      _showConfirmationDialog(sending);
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
              color: const Color.fromARGB(255, 111, 169, 240),
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
              controller: _emailController,
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
                _emailController.text = value!;
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

  Widget _buildResetPasswordBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          sendmassage();
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
          AppLocalizations.of(context)!.resetPassword,
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
