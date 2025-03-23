class Breathing {
  String type ;
  final String childId;
  final String titre;
  final String startTime;
  String? endTime;

  Breathing({
    this.type = 'breathing', // Set default value for type
    required this.childId,
    required this.titre,
    required this.startTime,
    this.endTime,
  });

  factory Breathing.fromMap(Map<String, dynamic> map) {
    return Breathing(
      type: map['type'] ?? 'breathing',
      childId: map['childId'] as String,
      titre: map['titre'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'childId': childId,
      'titre': titre,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
