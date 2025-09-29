import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/theme_service.dart';
import '../../products/product_controller.dart';
import '../../products/widgets/Product/barcode_scanner.dart';
import '../home_controller.dart';

class IndexMenu extends GetView<HomeController> {
  final int index;

  const IndexMenu({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Anasayfa Seçenekleri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Get.back();
                Get.offAllNamed(AppRoutes.screenSaver);
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Ekran Koruyucu"),
            ),
          ],
        );
      case 1:
        final prodPage = Get.find<ProductController>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ürün İşlemleri",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Get.back();
                prodPage.isSearching.value = false;
                controller.currentIndex.value = 1;
                prodPage.aktifSayfa.value = 1;
              },
              icon: const Icon(Icons.add),
              label: const Text("Ürünleri Göster"),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                Get.back();
                prodPage.isSearching.value = false;
                controller.currentIndex.value = 1;
                prodPage.aktifSayfa.value = 2;
              },
              icon: const Icon(Icons.download),
              label: const Text("Yeni Ürün Ekle"),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Get.back();
                Get.to(() => const BarcodeScanner(mod: 1));
              },
              // barkod ile ürün aranıcak ve tek ürün olacağı için dialog olabilir
              icon: const Icon(Icons.barcode_reader),
              label: const Text("Barkod İle Ürün Ara"),
            ),
          ],
        );
      case 3:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ayarlar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await Get.find<ThemeService>().toogleTheme();
                Get.back();
              },
              icon: const Icon(Icons.brightness_6),
              label: const Text("Tema Değiştir"),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
