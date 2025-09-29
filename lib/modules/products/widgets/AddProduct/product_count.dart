import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';

class ProductCount extends GetView<ProductController> {
  const ProductCount({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.productCountTextController,
      decoration: const InputDecoration(
        labelText: "Ürün Adeti",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2_sharp),
      ),
      keyboardType: TextInputType.number,
      maxLength: 4,
      onChanged: (value) {
        final parsed = int.tryParse(value);
        if (parsed != null && parsed > 0) {
          controller.urunAdet.value = parsed;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ürün sayısını giriniz";
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
