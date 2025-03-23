import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/contanat.dart';
import '../../utils/validators.dart';

class PhoneTextFieldController extends StatefulWidget {
  final Function(bool, String) onValidationChanged;
  final String inputText;
  final IconData? preficIcon;
  final TextEditingController controller;

  const PhoneTextFieldController(
      {super.key,
      required this.onValidationChanged,
      required this.inputText,
      required this.preficIcon,
      required this.controller});

  @override
  _InputTextFieldState createState() => _InputTextFieldState();

  String get inputValue => _InputTextFieldState().input;
}

class _InputTextFieldState extends State<PhoneTextFieldController> {
  String _input = '';
  bool _validateInput = true;
  String? _validateInputtext;

  @override
  Widget build(BuildContext context) {
    String hintmessag =
        "${AppLocalizations.of(context)!.inputhint} ${widget.inputText}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputText,
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
              color: _validateInput ? Colors.transparent : Colors.red,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                widget.preficIcon,
                color: _validateInput ? Colors.white : Colors.red,
              ),
              hintText: hintmessag,
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              _validateInputtext = validatePhone(value);
              if (_validateInputtext != null) {
                setState(() {
                  _validateInput = false;
                  widget.onValidationChanged(false, _input);
                });
                return null;
              } else {
                setState(() {
                  _validateInput = true;
                  widget.onValidationChanged(true, _input);
                });
                return null;
              }
            },
            onSaved: (value) {
              _input = value!;
              widget.onValidationChanged(true, _input);
            },
          ),
        ),
        _validateInput ? const SizedBox(height: 10.0) : const SizedBox(height: 0),
        _validateInput
            ? const SizedBox(height: 0)
            : Text(
                changeLang(_validateInputtext!),
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  String changeLang(String message) {
    if (message == "req") {
      return AppLocalizations.of(context)!.inputIsRequired;
    } else if (message == "Invalid") {
      return AppLocalizations.of(context)!.invalidPhoneNumber;
    }
    return "";
  }

  String get input => _input;
}
