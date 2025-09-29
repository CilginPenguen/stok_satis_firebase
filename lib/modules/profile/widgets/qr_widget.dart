import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stok_satis_firebase/modules/profile/profile_controller.dart';

class QrWidget extends GetView<ProfilePageController> {
  const QrWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: controller.qr.value,
        child: Center(
          child: QrImageView(
            data: controller.uidGetir(),
            version: QrVersions.auto,
            size: 200,
          ),
        ),
      );
    });
  }
}
