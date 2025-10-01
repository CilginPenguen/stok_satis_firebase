import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

class RejectedPage extends StatelessWidget {
  const RejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Reddedildi")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Girişiniz dükkan sahibi tarafından reddedildi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Get.offAllNamed(AppRoutes.signUp);
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Yeniden Kayıt Ol"),
            ),
          ],
        ),
      ),
    );
  }
}
