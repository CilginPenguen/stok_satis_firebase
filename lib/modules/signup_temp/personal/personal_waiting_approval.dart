import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/signup_temp/personal/personal_reject.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';

import '../../../routes/app_pages.dart';
import '../../../services/storage_service.dart';

class PersonalWaitingApproval extends GetView<SignupController> {
  const PersonalWaitingApproval({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final ownerUid = storage.getValue<String>("ownerUid");
    final staffUid = storage.getValue<String>("staffUid");

    if (ownerUid == null || staffUid == null) {
      return const Scaffold(
        body: Center(
          child: Text("Kayıt bilgileri bulunamadı, lütfen tekrar giriş yapın."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Onay Bekleniyor")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(ownerUid)
            .collection("staff")
            .doc(staffUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Kaydınız bulunamadı. Yeniden kayıt olun."),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final storage = Get.find<StorageService>();
                      storage.clear();
                      Get.offAllNamed(AppRoutes.signUp);
                    },
                    child: Text("Geri Dön"),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;

          // deviceApproval alanını çek
          final deviceApprovalMap =
              data['deviceApproval'] as Map<String, dynamic>?;

          if (deviceApprovalMap == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Cihaz kaydı bulunamadı, onay bekleniyor..."),
                ],
              ),
            );
          }

          final approved = deviceApprovalMap['approved'];

          if (approved == true) {
            Future.microtask(() => Get.offAllNamed(AppRoutes.home));
          } else if (approved == false) {
            final storage = Get.find<StorageService>();
            storage.clear();
            Future.microtask(() => Get.offAll(const RejectedPage()));
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  "Kaydınız dükkan sahibi tarafından onaylanmayı bekliyor...",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
