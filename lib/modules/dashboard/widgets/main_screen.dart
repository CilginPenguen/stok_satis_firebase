import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../../services/clock_service.dart';
import '../../../services/theme_service.dart';
import '../../home/home_controller.dart';
import '../../products/product_controller.dart';
import '../../products/widgets/Product/barcode_scanner.dart';
import '../dashboard_controller.dart';

class MainScreen extends GetView<DashboardController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clockS = Get.find<ClockService>();
    final themeS = Get.find<ThemeService>();
    final prodCont = Get.find<ProductController>();
    final homeCont = Get.find<HomeController>();

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: clockS.toggleClock,
                        child: const Text("Saati Göster"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: themeS.toogleTheme,
                        child: const Text("Temayı Değiştir"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () =>
                            Get.to(() => const BarcodeScanner(mod: 1)),
                        child: const Text("Ürün Bul"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          homeCont.currentIndex.value = 1;
                          prodCont.aktifSayfa.value = 2;
                        },
                        child: const Text("Ürün Ekle"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
