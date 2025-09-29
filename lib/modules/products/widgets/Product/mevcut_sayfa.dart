import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';
import '../AddProduct/add_product.dart';
import 'barcode_scanner.dart';
import '../../products_V2.dart';

class MevcutSayfa extends GetView<ProductController> {
  const MevcutSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.aktifSayfa.value) {
        case 1:
          return ProductByCategoryPage();
        case 2:
          return AddProduct();
        case 3:
          Future.microtask(() {
            Get.to(() => const BarcodeScanner(mod: 1));
            controller.sayfaDegistir(1); // geri dönünce ürün listesine geçsin
          });
          return const SizedBox();
        default:
          return const Center(child: Text("Sayfa Bulunamadı"));
      }
    });
  }
}
