import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/clock_service.dart';

class ClockSettings extends StatelessWidget {
  ClockSettings({super.key});

  final ClockService clockService = Get.find<ClockService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.lock_clock),
        title: Text('Saati Göster'),
        trailing: Obx(
          () => Switch(
            value: clockService.clockMode,
            onChanged: (value) => clockService.toggleClock(),
          ),
        ),
      ),
    );
  }
}
