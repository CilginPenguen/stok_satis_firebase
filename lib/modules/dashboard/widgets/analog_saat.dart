import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:get/state_manager.dart';

import '../dashboard_controller.dart';

class AnalogSaat extends GetView<DashboardController> {
  final bool screenSaver;
  const AnalogSaat({super.key, this.screenSaver = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dimension = size.width < size.height ? size.width : size.height;

    return Center(
      child: SizedBox(
        width: dimension * 0.6,
        height: dimension * 0.6,
        child: Theme.of(context).brightness == Brightness.dark
            ? AnalogClock.dark(hourNumbers: controller.sayiTipi)
            : AnalogClock(hourNumbers: controller.sayiTipi),
      ),
    );
  }
}
