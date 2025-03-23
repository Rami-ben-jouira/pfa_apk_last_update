import 'package:cloud_firestore/cloud_firestore.dart';

class NoteBook {
  String type ;
  final String childId;
  final String notes;
  final String pense;
  final String sentiments;
  final String comportement;
  final String resultat;
  final DateTime timestamp;

  NoteBook({
    this.type = 'note_book', // Set default value for type
    required this.childId,
    required this.notes,
    required this.pense,
    required this.sentiments,
    required this.comportement,
    required this.resultat,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'childId': childId,
      'notes': notes,
      'pense': pense,
      'sentiments': sentiments,
      'comportement': comportement,
      'resultat': resultat,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory NoteBook.fromMap(Map<String, dynamic> map) {
    return NoteBook(
      type: map['type'] ?? 'note_book',
      childId: map['idEnfant'] as String,
      notes: map['notes'] as String,
      pense: map['pense'] as String,
      sentiments: map['sentiments'] as String,
      comportement: map['comportement'] as String,
      resultat: map['resultat'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
