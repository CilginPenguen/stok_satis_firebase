import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';
import 'barcode_scanner.dart';

class ProductFloatingAction extends GetView<ProductController> {
  const ProductFloatingAction({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      visible: !controller.isSearching.value,
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.blueGrey.withAlpha(123),
      direction: SpeedDialDirection.up,
      children: [
        SpeedDialChild(
          child: Icon(Icons.inventory_2_outlined),
          label: 'Ürünler',
          onTap: () => controller.aktifSayfa.value = 1,
        ),
        SpeedDialChild(
          child: Icon(Icons.add_box),
          label: "Ürün Ekle",
          onTap: () => controller.aktifSayfa.value = 2,
        ),
        SpeedDialChild(
          child: Icon(Icons.camera_enhance),
          label: 'Barkod İle Ara',
          onTap: () => Get.to(() => const BarcodeScanner(mod: 1)),
        ),
      ],
    );
  }
}
