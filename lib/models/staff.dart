import 'package:cloud_firestore/cloud_firestore.dart';

import 'deviceapproval.dart';
import 'permissions.dart';

class Staff {
  final String? staffUid; // docId atanabilir
  final String name;
  final String surname;
  final Permissions permissions;
  final DateTime joinedAt;
  final DeviceApproval deviceApproval;

  Staff({
    this.staffUid,
    required this.name,
    required this.surname,
    required this.permissions,
    required this.joinedAt,
    required this.deviceApproval,
  });

  factory Staff.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Staff(
      staffUid: map['staffUid'] ?? docId,
      name: map['firstName'] ?? '',
      surname: map['lastName'] ?? '',
      permissions: Permissions.fromMap(map['permissions'] ?? {}),
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deviceApproval: DeviceApproval.fromMap(map['deviceApproval'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffUid': staffUid,
      'firstName': name,
      'lastName': surname,
      'permissions': permissions.toMap(),
      'joinedAt': joinedAt,
      'deviceApproval': deviceApproval.toMap(),
    };
  }
}
