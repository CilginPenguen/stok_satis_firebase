import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';

class ProductBarcode extends GetView<ProductController> {
  const ProductBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.barkodTextController,
      decoration: const InputDecoration(
        labelText: "Ürün Barkodu",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2_sharp),
      ),
      keyboardType: TextInputType.number,
      maxLength: 15,
      onChanged: (value) {
        final parsed = int.tryParse(value);
        if (parsed != null && parsed > 0) {
          controller.urunBarkod.value = parsed.toString();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ürün barkodunu giriniz veya taratınız";
        }
        final amount = int.tryParse(value);
        if (amount == null || amount <= 0) {
          return "Geçersiz veri";
        }
        return null;
      },
    );
  }
}
