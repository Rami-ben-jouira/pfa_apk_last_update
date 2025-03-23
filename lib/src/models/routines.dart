import 'package:cloud_firestore/cloud_firestore.dart';

class Routines {
  String type;
  String childId;
  FieldValue timestamp;
  Map<String, String> responses;

  Routines({
    this.type = 'routine', // Set default value for type
    required this.childId,
    required this.timestamp,
    required this.responses,
  });

  // Convert Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'childId': childId,
      'timestamp': timestamp,
      'responses': responses,
    };
  }

  // Create a Message object from a map
  factory Routines.fromMap(Map<String, dynamic> map) {
    return Routines(
      type: map['type'] ?? 'routine',
      childId: map['childId'] ?? '',
      timestamp: (map['timestamp'] as FieldValue),
      responses: Map<String, String>.from(map['responses']),
    );
  }
}
