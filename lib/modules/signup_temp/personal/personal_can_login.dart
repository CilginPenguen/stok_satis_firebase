import 'package:flutter/material.dart';

class PersonalCanLogin extends StatelessWidget {
  const PersonalCanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Onayı Bekleme")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Girişiniz Yetkili Tarafından Kapatılmıştır. Lütfen Yetkiliyle İletişime Geçiniz.",
            ),
          ],
        ),
      ),
    );
  }
}
