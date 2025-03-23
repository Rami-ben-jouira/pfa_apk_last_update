import 'package:flutter/material.dart';

class SubmitButtonStyle extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color color;

  const SubmitButtonStyle({super.key, 
    required this.onPressed,
    required this.buttonText, 
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: color,
        ),
        child: Text(
          buttonText,
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
}
