import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stok_satis_firebase/modules/login/login_controller.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';

class QrScanner extends GetView<LoginController> {
  const QrScanner({super.key, required this.forSignUp});
  final bool forSignUp;

  @override
  Widget build(BuildContext context) {
    bool scanned = false;
    return Stack(
      children: [
        MobileScanner(
          controller: controller.qrController,
          onDetect: (capture) {
            if (!forSignUp) {
              if (!scanned) {
                final barcode = capture.barcodes.first;
                if (barcode.format != BarcodeFormat.qrCode) return;

                final qrValue = barcode.rawValue;

                if (qrValue != null && qrValue.isNotEmpty) {
                  scanned = true;
                  controller.uidController.text = qrValue;
                  print(qrValue);
                  Get.back();
                }
              }
            } else {
              if (!scanned) {
                final barcode = capture.barcodes.first;
                final qrValue = barcode.rawValue;
                final t = Get.find<SignupController>();

                if (qrValue != null && qrValue.isNotEmpty) {
                  scanned = true;
                  t.uidController.text = qrValue;
                  print(qrValue);
                  Get.back();
                }
              }
            }
          },
        ),
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                await controller.qrController.stop();
                Get.back();
              },
            ),
          ),
        ),

        /// Flash butonu
        Positioned(
          top: 40,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white),
              onPressed: () {
                controller.qrController.toggleTorch();
              },
            ),
          ),
        ),

        /// Kamera değiştirme butonu
        Positioned(
          top: 40,
          right: 70,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.cameraswitch, color: Colors.white),
              onPressed: () {
                controller.qrController.switchCamera();
              },
            ),
          ),
        ),
      ],
    );
  }
}
