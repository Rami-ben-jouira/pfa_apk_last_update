class ChildProfil {
  final String parentUid;
  final String name;
  final int age;
  final String gender;
  final String schoolLevel;
  final bool hasMedicalCondition;
  final String medicalCondition;
  final String medicationName;

  ChildProfil({
    required this.parentUid,
    required this.name,
    required this.age,
    required this.gender,
    required this.schoolLevel,
    required this.hasMedicalCondition,
    this.medicalCondition = '',
    this.medicationName = '',
  });

  // Create a ChildProfil instance from a map.
  factory ChildProfil.fromMap(Map<String, dynamic> map) {
    return ChildProfil(
      parentUid: map['parentUid'],
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      schoolLevel: map['schoolLevel'] ?? '',
      hasMedicalCondition: map['hasMedicalCondition'] ?? false,
      medicalCondition: map['medicalCondition'] ?? '',
      medicationName: map['medicationName'] ?? '',
    );
  }

  // Convert a ChildProfil instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'parentUid':parentUid,
      'name': name,
      'age': age,
      'gender': gender,
      'schoolLevel': schoolLevel,
      'hasMedicalCondition': hasMedicalCondition,
      'medicalCondition': medicalCondition,
      'medicationName': medicationName,
    };
  }
}
