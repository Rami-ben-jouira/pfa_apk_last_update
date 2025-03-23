import 'package:cloud_firestore/cloud_firestore.dart';

class Emotions {
  String type ;
  final String childId;
  final FieldValue timestamp;
  final String date;
  final String event;
  final String emotion;

  Emotions({
    this.type = 'emotion', // Set default value for type
    required this.childId,
    required this.timestamp,
    required this.date,
    required this.event,
    required this.emotion,
  });

  factory Emotions.fromMap(Map<String, dynamic> map) {
    return Emotions(
      type: map['type'] ?? 'emotion',
      childId: map['childId'] as String,
      timestamp: map['timestamp'] as FieldValue,
      date: map['date'] as String,
      event: map['event'] as String,
      emotion: map['emotion'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'childId': childId,
      'timestamp': timestamp,
      'date': date,
      'event': event,
      'emotion': emotion,
    };
  }
}