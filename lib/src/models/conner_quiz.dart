import 'package:cloud_firestore/cloud_firestore.dart';

class ConnerQuiz {
  String childId;
  FieldValue timestamp;
  Map<String, String>  responses;
  int totalScore;
  int scoreA;
  int scoreB;
  int scoreC;
  int scoreD;
  int scoreE;
  int scoreF;

  

  ConnerQuiz({
    required this.childId,
    required this.timestamp,
    required this.responses,
    required this.totalScore,
    required this.scoreA,
    required this.scoreB,
    required this.scoreC,
    required this.scoreD,
    required this.scoreE,
    required this.scoreF,
  });

  // Convert Message object to a map
 Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'timestamp': FieldValue.serverTimestamp(),
      'responses': responses,
      'totalScore': totalScore,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'scoreC': scoreC,
      'scoreD': scoreD,
      'scoreE': scoreE,
      'scoreF': scoreF,
    };
  }


  // Create a Message object from a map
factory ConnerQuiz.fromMap(Map<String, dynamic> map) {
    return ConnerQuiz(
      childId: map['childId'] ?? '',
      timestamp: (map['lastModifiedTime'] as FieldValue),
      responses: Map<String, String>.from(map['responses']),
      totalScore: map['totalScore'] ?? 0,
      scoreA: map['scoreA'] ?? 0,
      scoreB: map['scoreB'] ?? 0,
      scoreC: map['scoreC'] ?? 0,
      scoreD: map['scoreD'] ?? 0,
      scoreE: map['scoreE'] ?? 0,
      scoreF: map['scoreF'] ?? 0,
    );
  }
}
