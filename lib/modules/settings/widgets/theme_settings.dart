import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/theme_service.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Card(
      child: ListTile(
        leading: Icon(Icons.brightness_6),
        title: Text('Tema'),
        trailing: Obx(
          () => Switch(
            value: themeService.isDarkMode,
            onChanged: (value) => themeService.toogleTheme(),
          ),
        ),
      ),
    );
  }
}
