import 'package:adhd_helper/constants/textstyle.dart';
import 'package:flutter/material.dart';

class RadioFormWidget extends StatefulWidget {
  final String question;
  final List<String> answers;
  final Function(int) onSelectionChanged;

  const RadioFormWidget(
      {super.key, required this.question,
      required this.answers,
      required this.onSelectionChanged});

  @override
  _RadioFormWidgetState createState() => _RadioFormWidgetState();
}

class _RadioFormWidgetState extends State<RadioFormWidget> {
  int _selectedAnswer = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
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
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.question, style: smallTextstyle),
              Column(
                children:
                    List<Widget>.generate(widget.answers.length, (int index) {
                  return Row(
                    children: [
                      Radio<int>(
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          // Set the color for both active and inactive states
                          return Colors.white;
                        }),
                        activeColor: Colors.white,
                        value: index,
                        groupValue: _selectedAnswer,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedAnswer = value!;
                            widget.onSelectionChanged(
                                value); // Notify the parent widget
                          });
                        },
                      ),
                      Text(widget.answers[index], style: radioTextstyle),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
