import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/contanat.dart';
import '../../utils/validators.dart';

class EmailTextField extends StatefulWidget {
 final Function(bool, String) onValidationChanged;

  const EmailTextField({super.key, required this.onValidationChanged});

  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();

  String get emailValue => _EmailTextFieldState().email;
}

class _EmailTextFieldState extends State<EmailTextField> {
  String _email = '';
  bool _validateEmail = true;
  String? _validateEmailtext;

  @override
  Widget build(BuildContext context) {
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
                color: _validateEmail ? Colors.white : Colors.red,
              ),
              hintText: AppLocalizations.of(context)!.emailhint,
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              _validateEmailtext = validateEmail(value);
              if (_validateEmailtext != null) {
                setState(() {
                  _validateEmail = false;
                  widget.onValidationChanged(false,_email);
                });
                return null;
              } else {
                setState(() {
                  _validateEmail = true;
                  widget.onValidationChanged(true,_email);
                });
                return null;
              }
            },
            onSaved: (value) {
              _email = value!;
              widget.onValidationChanged(true,_email);
            },
          ),
        ),
        _validateEmail ? const SizedBox(height: 10.0) : const SizedBox(height: 0),
        _validateEmail
            ? const SizedBox(height: 0)
            : Text(
                changeLang(_validateEmailtext!),
                style: const TextStyle(color: Colors.red),
              ),
      ],
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

  
  String get email => _email;

}
