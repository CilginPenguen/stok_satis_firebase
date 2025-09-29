import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final DateTime joinedAt;

  Owner({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.joinedAt,
  });

  factory Owner.fromMap(String uid, Map<String, dynamic> map) {
    return Owner(
      uid: uid,
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      email: map['email'] ?? '',
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'joinedAt': joinedAt,
    };
  }
}
