import 'package:adhd_helper/src/screens/home_screen.dart';
import 'package:adhd_helper/src/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen> {
  String? selectedChildId;

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Child'),
      ),
      body: FutureBuilder<List<String>>(
        future: _firestoreService
            .getChildrenNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading children: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final childrenIds = snapshot.data!;
            return ListView.builder(
              itemCount: childrenIds.length,
              itemBuilder: (context, index) {
                String childname = childrenIds[index];
                return ListTile(
                  title: Text(childname), // Replace with actual child name
                  onTap: () {
                    setState(() {
                      selectedChildId = childname;
                    });
                  },
                  selected: selectedChildId == childname,
                );
              },
            );
          } else {
            return const Center(child: Text('No children found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedChildId != null) {
            await _firestoreService.updateCurrentChildId(selectedChildId!);
            // Navigate to the child's home screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else {
            // Show an error message or a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a child.'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
