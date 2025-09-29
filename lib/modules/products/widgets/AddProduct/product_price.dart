import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../../../utils/product_price_formatter.dart';
import '../../product_controller.dart';

class ProductPrice extends GetView<ProductController> {
  const ProductPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.productPriceTextController,
      decoration: InputDecoration(
        labelText: "Ürün Fiyatı",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money_outlined),
      ),
      maxLength: 8,
      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        controller.urunFiyat.value =
            double.tryParse(value) ?? controller.urunFiyat.value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Miktarı Giriniz";
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return "Geçersiz Veri";
        }
        return null;
      },
    );
  }
}
