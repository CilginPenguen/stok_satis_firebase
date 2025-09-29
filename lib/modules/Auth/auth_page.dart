import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/Auth/auth_controller.dart';
import 'package:stok_satis_firebase/services/storage_service.dart';

import '../../core/base_controller.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import '../signup_temp/verify_page.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final baseController = Get.find<BaseController>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Owner akışı
        if (user != null) {
          if (!user.emailVerified) {
            return const VerifyPage();
          }
          return const HomePage();
        }

        // Staff akışı
        final ownerUid = storage.getValue<String>("ownerUid");
        final staffUid = storage.getValue<String>("staffUid");

        if (ownerUid != null && staffUid != null) {
          return StreamBuilder<Widget>(
            stream: baseController.checkDeviceApprovalStream(
              ownerUid: ownerUid,
              staffUid: staffUid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                final storage = Get.find<StorageService>();
                storage.clear();
                return const LoginPage();
              }

              if (!snapshot.hasData) {
                final storage = Get.find<StorageService>();
                storage.clear();
                return const LoginPage();
              }

              return snapshot.data!;
            },
          );
        }

        // Ne owner ne staff varsa login ekranı
        return const LoginPage();
      },
    );
  }
}
