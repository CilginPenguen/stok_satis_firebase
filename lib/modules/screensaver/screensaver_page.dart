import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

import 'screensaver_controller.dart';

class ScreensaverPage extends GetView<ScreensaverController> {
  const ScreensaverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.offNamed(AppRoutes.home, preventDuplicates: false),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: AnalogClock()),
      ),
    );
  }
}
