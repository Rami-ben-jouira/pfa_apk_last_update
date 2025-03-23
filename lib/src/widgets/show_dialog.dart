import 'package:flutter/material.dart';
import '../../constants/textstyle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void ShowDialog(BuildContext context, String title, String message,
    bool isSuccess, Widget loginScreen) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 113, 187, 245),
        title: Column(
          children: [
            Container(
              width: 70, // Adjust the width and height as needed
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Change the color as needed
              ),
              child: Center(
                child: Icon(
                  isSuccess ? Icons.done : Icons.close,
                  color: const Color.fromARGB(255, 113, 187, 245),
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: alertDiagTitleStyle,
            ),
          ],
        ),
        content: Text(
          message,
          style: alertDiagtextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (isSuccess) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => loginScreen,
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.close,
              style: alertDiagactionStyle,
            ),
          ),
        ],
      );
    },
  );
}
