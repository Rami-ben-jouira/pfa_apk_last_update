
class EmotionWave {
  String type ;
  final String childId;
  final String titre;
  final String startTime;
  String? endTime;

  EmotionWave({
    this.type = 'emotion_wave', // Set default value for type
    required this.childId,
    required this.titre,
    required this.startTime,
     this.endTime,
  });

  factory EmotionWave.fromMap(Map<String, dynamic> map) {
    return EmotionWave(
      type: map['type'] ?? 'emotion_wave',
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