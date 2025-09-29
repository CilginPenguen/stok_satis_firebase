import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';

class SaveButton extends GetView<ProductController> {
  final String? urunId;

  const SaveButton({super.key, this.urunId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                if (controller.urunGuncelleme.value) {
                  Get.back(closeOverlays: true);
                  controller.urunGuncelleme.value = false;
                  controller.clearForm();
                } else {
                  controller.aktifSayfa.value = 1;
                  controller.clearForm();
                }
              },
              label: const Text("İPTAL", style: TextStyle(fontSize: 12)),
              icon: const Icon(Icons.cancel, color: Colors.red, size: 24),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                if (controller.formKey.currentState?.validate() ?? false) {
                  if (controller.urunGuncelleme.value && urunId != null) {
                    await controller.urunGuncelle(urunId!);
                    controller.urunGuncelleme.value = false;
                    controller.clearForm();
                    controller.showSuccessSnackbar(
                      message: "Ürün Başarıyla Güncellendi",
                    );
                  } else {
                    await controller.urunEkleFirebase();
                  }
                }
              },
              label: Text(
                style: TextStyle(fontSize: 12),
                controller.urunGuncelleme.value ? "Güncelle" : "Kaydet",
              ),
              icon: Icon(
                controller.urunGuncelleme.value ? Icons.update : Icons.save,
                color: Colors.green,
                size: 24,
              ),
            ),
          ),
        ],
      );
    });
  }
}
