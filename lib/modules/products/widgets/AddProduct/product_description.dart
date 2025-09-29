import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../product_controller.dart';

class ProductDescription extends GetView<ProductController> {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.productDescriptionTextController,
      decoration: InputDecoration(
        hintText: "Kısa Tutunuz(50 Sayfa,Mavi vb.)",
        labelText: "Ürün Tanımı",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.abc_outlined),
      ),
      maxLength: 10,
      onChanged: (value) {
        controller.urunDescription.value = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ürün Tanımı Giriniz";
        }
        return null;
      },
    );
  }
}
