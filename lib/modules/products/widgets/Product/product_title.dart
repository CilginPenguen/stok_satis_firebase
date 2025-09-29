import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';

class ProductTitle extends GetView<ProductController> {
  final bool shop;
  const ProductTitle({required this.shop, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isSearching.value
          ? TextField(
              cursorColor: Colors.red,
              onChanged: (value) {
                controller.searchProduct.value = value;
              },
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Kelimeyi Buraya Yazınız",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white60),
              ),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                fontSize: 18,
              ),
            )
          : shop
          ? Text("Sepet")
          : Text("Ürünler"),
    );
  }
}
