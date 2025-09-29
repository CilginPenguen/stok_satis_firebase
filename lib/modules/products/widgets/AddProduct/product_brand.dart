import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../product_controller.dart';

class ProductBrand extends GetView<ProductController> {
  final toggle = false.obs;
  ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => toggle.value
                ? DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.abc_outlined),
                    ),
                    hint: Text("Marka seç"),
                    initialValue:
                        controller.markalar.contains(controller.marka.value)
                        ? controller.marka.value
                        : null,
                    items: controller.markalar
                        .where((e) => e.isNotEmpty) // boş stringleri filtrele
                        .map(
                          (marka) => DropdownMenuItem(
                            value: marka,
                            child: Text(marka),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.marka.value = value!;
                    },
                  )
                : TextFormField(
                    controller: controller.productMarkaTextController,
                    decoration: InputDecoration(
                      labelText: "Marka Giriniz",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.abc_outlined),
                    ),
                    maxLength: 15,
                    onChanged: (value) {
                      controller.marka.value = value;
                    },
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Kayıtlı Mı?"),
            Obx(
              () => Switch(
                value: toggle.value,
                onChanged: (value) => toggle.value = value,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
