class Doctor {
  String uid;
  String name;
  String address;
  String specialization;
  String phone_number;
  String email;
  Map<String, dynamic> confirmedPatients;

  Doctor(
      {required this.uid,
      required this.name,
      required this.address,
      required this.specialization,
      required this.phone_number,
      required this.email,
      required this.confirmedPatients});

  // Convert Doctor object to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'specialization': specialization,
      'phone_number': phone_number,
      'email': email,
      'confirmedPatients': confirmedPatients
    };
  }

  // Create a Doctor object from a Map
  static Doctor fromMap(Map<String, dynamic> map) {
    return Doctor(
        uid: map['uid'] as String,
        name: map['name'] as String,
        address: map['address'] as String,
        specialization: map['specialization'] as String,
        phone_number: map['phone_number'] as String,
        email: map['email'] as String,
        confirmedPatients: map['confirmedPatients'] as Map<String, dynamic>);
  }
}
