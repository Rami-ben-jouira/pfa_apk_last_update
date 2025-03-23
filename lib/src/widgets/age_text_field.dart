import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/contanat.dart';
import '../../utils/validators.dart';

class AgeTextField extends StatefulWidget {
  final Function(bool, String) onValidationChanged;
  final String ageText;
  final IconData? preficIcon;

  const AgeTextField(
      {super.key,
      required this.onValidationChanged,
      required this.ageText,
      required this.preficIcon});

  @override
  _AgeTextFieldState createState() => _AgeTextFieldState();

  String get ageValue => _AgeTextFieldState().age;
}

class _AgeTextFieldState extends State<AgeTextField> {
  String _age = '';
  bool _validateAge = true;
  String? _validateAgetext;

  @override
  Widget build(BuildContext context) {
    String hintmessag =
        "${AppLocalizations.of(context)!.inputhint} ${widget.ageText}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.ageText,
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
              color: _validateAge ? Colors.transparent : Colors.red,
              width: 2.0,
            ),
          ),
          height: 60.0,
          child: TextFormField(
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
                color: _validateAge ? Colors.white : Colors.red,
              ),
              hintText: hintmessag,
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              _validateAgetext = validateAge(value);
              if (_validateAgetext != null) {
                setState(() {
                  _validateAge = false;
                  widget.onValidationChanged(false, _age);
                });
                return null;
              } else {
                setState(() {
                  _validateAge = true;
                  widget.onValidationChanged(true, _age);
                });
                return null;
              }
            },
            onSaved: (value) {
              _age = value!;
              widget.onValidationChanged(true, _age);
            },
          ),
        ),
        _validateAge ? const SizedBox(height: 10.0) : const SizedBox(height: 0),
        _validateAge
            ? const SizedBox(height: 0)
            : Text(
                changeLang(_validateAgetext!),
                style: const TextStyle(color: Colors.red),
              ),
      ],
    );
  }

  String changeLang(String message) {
    if (message == "req") {
      return AppLocalizations.of(context)!.enterAge;
    } else if (message == "age range") {
      return AppLocalizations.of(context)!.ageRange;
    }
    return "";
  }

  String get age => _age;
}
