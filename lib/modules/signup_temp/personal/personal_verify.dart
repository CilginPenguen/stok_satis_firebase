import 'package:flutter/material.dart';

class PersonalVerify extends StatelessWidget {
  const PersonalVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Onay Bekleme")),
      body: Column(
        children: [
          Text("Onaylanması İçin Lütfen Dükkan Sahibiyle İletişime Geçiniz"),
          TextButton.icon(
            onPressed: () {},
            label: Text("Onay Durumunu Kontrol Et"),
            icon: Icon(Icons.replay_outlined),
          ),
        ],
      ),
    );
  }
}
