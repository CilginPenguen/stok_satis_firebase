import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

class VerifyPage extends GetView<SignupController> {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mail Doğrulama")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lütfen Mail Adresinize Gelen Maili Onaylayınız.\n Spam Klasörüne düşmüş olabilir",
              style: TextStyle(),
            ),
            OutlinedButton(
              onPressed: controller.isSending.value
                  ? null
                  : (controller.onayMail),
              child: controller.isSending.value
                  ? const CircularProgressIndicator()
                  : const Text("Maili Yeniden Gönder"),
            ),
            OutlinedButton(
              onPressed: controller.onayKontrol,
              child: const Text("Doğrulamayı Kontrol Et"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.auth);
              },
              child: Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
