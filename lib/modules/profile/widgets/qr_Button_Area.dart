import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/owner.dart';
import '../profile_controller.dart';
import 'qr_widget.dart';

class QrButtonArea extends GetView<ProfilePageController> {
  const QrButtonArea({super.key, required this.o});

  final Owner? o;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.checkOwner(),
      child: Obx(() {
        return controller.qr.value
            ? Column(
                children: [
                  SizedBox(height: 200, width: 200, child: QrWidget()),
                  TextButton.icon(
                    onPressed: () => controller.qr.value = !controller.qr.value,
                    icon: !controller.qr.value
                        ? Icon(Icons.qr_code_2)
                        : Icon(Icons.close_sharp),
                    label: !controller.qr.value
                        ? Text("QR GÖSTER")
                        : Text("QR KAPAT"),
                  ),
                ],
              )
            : TextButton.icon(
                onPressed: () => controller.qr.value = !controller.qr.value,
                icon: !controller.qr.value
                    ? Icon(Icons.qr_code_2)
                    : Icon(Icons.close_sharp),
                label: !controller.qr.value
                    ? Text("QR GÖSTER")
                    : Text("QR KAPAT"),
              );
      }),
    );
  }
}
