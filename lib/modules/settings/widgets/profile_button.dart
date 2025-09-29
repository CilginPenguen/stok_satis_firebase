import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.profile),
            label: Text("Profilim"),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
