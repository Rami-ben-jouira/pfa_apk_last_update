import 'package:adhd_helper/constants/appbar.dart';
import 'package:adhd_helper/src/models/notebook.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'cognitive_activites_screen.dart';
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/constants/textstyle.dart'; // Import the text styles
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NotebookFormsScreen extends StatefulWidget {
  const NotebookFormsScreen({super.key});

  @override
  State<NotebookFormsScreen> createState() => _NotebookFormsScreenState();
}

class _NotebookFormsScreenState extends State<NotebookFormsScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final FirestoreService _storeService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, // Use the same appBar as in KidsHomeScreen
      body: Stack(
        children: [
          background, // Use the same background as in KidsHomeScreen
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSection(
                    title: AppLocalizations.of(context)!.situation,
                    controller: _controller,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: AppLocalizations.of(context)!.idea,
                    controller: _controller1,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: AppLocalizations.of(context)!.feelings,
                    controller: _controller2,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: AppLocalizations.of(context)!.behavior,
                    controller: _controller3,
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    title: AppLocalizations.of(context)!.result,
                    controller: _controller4,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFF4511E),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.saveInformation,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Use white background for sections
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: bigTextstyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              maxLines: null,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.writeHere,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            Text(
              controller.text,
              style: midTextstyle.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    if (_controller.text.isEmpty ||
        _controller1.text.isEmpty ||
        _controller2.text.isEmpty ||
        _controller3.text.isEmpty ||
        _controller4.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.answerAllQuestions,
            style: midTextstyle.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber.shade100, // Custom background color
          title: Text(
            AppLocalizations.of(context)!.confirmation,
            style: bigTextstyle.copyWith(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.confirmSaveInformation,
                  style: midTextstyle.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: midTextstyle.copyWith(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: midTextstyle.copyWith(color: Colors.blue),
              ),
              onPressed: () async {
                _saveData();
                _showSuccessMessage();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveData() async {
    String? childId = await _storeService.getCurrentChildId();
    NoteBook noteBook = NoteBook(
      childId: childId!,
      notes: _controller.text,
      pense: _controller1.text,
      sentiments: _controller2.text,
      comportement: _controller3.text,
      resultat: _controller4.text,
      timestamp: DateTime.now(),
    );
    _storeService.addNotebook(noteBook);
  }

  Future<void> _showSuccessMessage() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.informationSavedSuccessfully,
          style: midTextstyle.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CognitiveActiviteScreen(),
      ),
    );
  }
}
