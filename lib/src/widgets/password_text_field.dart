import 'package:flutter/material.dart';

import '../../constants/contanat.dart';
import '../../utils/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordTextField extends StatefulWidget {
  final Function(bool, String) onValidationChanged;

  const PasswordTextField({Key? key, required this.onValidationChanged})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();

  String get passwordValue => _PasswordTextFieldState().password;
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  String _password = '';
  bool _validatePWD = true;
  String? _validatePWDText;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
                color: _validatePWD ? Colors.white : Colors.red,
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
                  _validatePWD = false;
                  widget.onValidationChanged(false, _password);
                });
                return null;
              } else {
                setState(() {
                  _validatePWD = true;
                  widget.onValidationChanged(true, _password);
                });
                return null;
              }
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
        ),
        _validatePWD ? const SizedBox(height: 10.0) : const SizedBox(height: 0),
        _validatePWD
            ? const SizedBox(height: 0)
            : Text(
                _validatePWDText!,
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  String get password => _password;
}
