class Questionnaire {
  String childid; // User ID
  List<int> questions; // List of questions
  int result; // Integer to store the result


  Questionnaire({
    required this.childid,
    required this.questions,
    this.result = -1,

  });

  // Create a factory constructor to convert a Map to a Questionnaire object
  factory Questionnaire.fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      childid: map['childid'],
      questions: List<int>.from(map['questions']),
      result: map['result'],

    );
  }

  // Create a method to convert the Questionnaire object to a Map
  Map<String, dynamic> toMap() {
    return {
      'childid': childid,
      'questions': questions,
      'result': result,

    };
  }
}
