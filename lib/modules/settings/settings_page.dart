import 'package:flutter/material.dart';
import 'package:stok_satis_firebase/modules/settings/widgets/clock_settings.dart';
import 'package:stok_satis_firebase/modules/settings/widgets/language_settings.dart';
import 'package:stok_satis_firebase/modules/settings/widgets/profile_button.dart';
import 'package:stok_satis_firebase/modules/settings/widgets/theme_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar")),
      body: Column(
        children: [ThemeSettings(), ClockSettings(), ProfileButton()],
      ),
    );
  }
}
