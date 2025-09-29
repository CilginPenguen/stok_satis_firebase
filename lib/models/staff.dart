import 'package:cloud_firestore/cloud_firestore.dart';

import 'deviceapproval.dart';
import 'permissions.dart';

class Staff {
  final String? staffUid; // docId atanabilir
  final String firstName;
  final String lastName;
  final Permissions permissions;
  final DateTime joinedAt;
  final DeviceApproval deviceApproval;

  Staff({
    this.staffUid,
    required this.firstName,
    required this.lastName,
    required this.permissions,
    required this.joinedAt,
    required this.deviceApproval,
  });

  factory Staff.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Staff(
      staffUid: map['staffUid'] ?? docId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      permissions: Permissions.fromMap(map['permissions'] ?? {}),
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deviceApproval: DeviceApproval.fromMap(map['deviceApproval'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffUid': staffUid,
      'firstName': firstName,
      'lastName': lastName,
      'permissions': permissions.toMap(),
      'joinedAt': joinedAt,
      'deviceApproval': deviceApproval.toMap(),
    };
  }
}
