import 'package:cloud_firestore/cloud_firestore.dart';

class Activites {
  String type ;
  String childId;
  String section;
  String activite;
  FieldValue timestamp;


  

  Activites({
    this.type = 'activite', // Set default value for type
    required this.childId,
    required this.section,
    required this.activite,
    required this.timestamp,
    
  });

  // Convert Message object to a map
 Map<String, dynamic> toMap() {
    return {
      'type': type,
      'childId': childId,
      'section': section,
      'activite':activite,
      'timestamp': timestamp,


    };
  }


  // Create a Message object from a map
factory Activites.fromMap(Map<String, dynamic> map) {
    return Activites(
      type: map['type'] ?? 'activite',
      childId: map['childId'] ?? '',
      section: map['section'] ?? '',
      activite: map['activite'] ?? '',
      timestamp: (map['timestamp'] as FieldValue),
      
    );
  }
}
