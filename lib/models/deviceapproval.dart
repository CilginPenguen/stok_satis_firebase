import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceApproval {
  final String deviceId;
  final DateTime requestDate;
  final bool? approved;
  final bool canLogin; // Yeni eklenen alan

  DeviceApproval({
    required this.deviceId,
    required this.requestDate,
    this.approved,
    this.canLogin = false, // Varsayılan değer false
  });

  factory DeviceApproval.fromMap(Map<String, dynamic> map) {
    return DeviceApproval(
      deviceId: map['deviceId'] ?? '',
      requestDate: (map['requestDate'] as Timestamp).toDate(),
      approved: map['approved'],
      canLogin: map['canLogin'] ?? false, // Firestore'dan gelen değeri al, yoksa false
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'requestDate': Timestamp.fromDate(requestDate),
      'approved': approved,
      'canLogin': canLogin,
    };
  }

  /// dd-MM-yyyy formatı
  String get formattedDate {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(requestDate);
  }
}
