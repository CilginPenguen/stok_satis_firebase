import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../basket/basket_controller.dart';
import '../../product_controller.dart';
import 'barcode_scanner.dart';

class ProductActions extends GetView<ProductController> {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: Get.isRegistered<BasketController>(),
          child: IconButton(
            onPressed: () => Get.to(BarcodeScanner(mod: 3)),
            icon: const Icon(Icons.barcode_reader),
          ),
        ),
      ],
    );
  }
}
