class UserProfile {
  final String uid;
  final String? email;
  String firstName;
  String lastName;
  String number;
  bool spouse;
  String? spouseFirstName;
  String? spouseLastName;
  String? spouseNumber;
  String? spouseEmail;
  String? doctorUid;
  bool? isConfirmed;
  final List<String> childrenIds;
  String? currentChildId;

  UserProfile(
      {required this.uid,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.number,
      required this.spouse,
      this.spouseFirstName,
      this.spouseLastName,
      this.spouseNumber,
      this.spouseEmail,
      this.doctorUid,
      this.childrenIds = const [], // Initialize as empty list
      this.currentChildId});

  // Create a factory constructor to convert a map (e.g., from Firestore) to a UserProfile object.
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      number: map['number'] ?? '',
      spouse: map['spouse'] ?? false,
      spouseFirstName: map['spouseFirstName'],
      spouseLastName: map['spouseLastName'],
      spouseNumber: map['spouseNumber'],
      spouseEmail: map['spouseEmail'],
      doctorUid: map['doctorUid'],
      childrenIds: List<String>.from(map['childrenIds'] ?? []),
      currentChildId: map['currentChildId'],
    );
  }

  // Convert a UserProfile object to a map for saving to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'number': number,
      'spouse': spouse,
      'spouseFirstName': spouseFirstName,
      'spouseLastName': spouseLastName,
      'spouseNumber': spouseNumber,
      'spouseEmail': spouseEmail,
      'doctorUid': doctorUid,
      'childrenIds': childrenIds,
      'currentChildId': currentChildId, // Include childrenIds in the map
    };
  }
}
