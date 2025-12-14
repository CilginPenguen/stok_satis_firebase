import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/basket/basket_page.dart';
import 'package:stok_satis_firebase/modules/desktop/desktop_controller.dart';
import '../../routes/app_pages.dart';
import 'widgets/buildMenuButton.dart';

class DesktopPage extends GetView<DesktopController> {
  const DesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Stok Satış Takip",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 24),

            /// 🔹 Ortadaki Switch alanları
            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  Ürün Ekleme Switch
                    Row(
                      children: [
                        const Text(
                          "Sepet Modu",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        Switch(
                          activeThumbColor: Colors.teal,
                          value: controller.urunEklemeBool.value,
                          onChanged: (val) => controller.setEkleme(val),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),

                    //  Ürün Düzenleme Switch
                    Row(
                      children: [
                        const Text(
                          "Düzenleme Modu",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        Switch(
                          activeThumbColor: Colors.amber,
                          value: controller.urunDuzenleBool.value,
                          onChanged: (val) => controller.setDuzenle(val),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => exit(0),
            icon: const Icon(Icons.power_settings_new_outlined),
          ),
          IconButton(
            onPressed: () async {
              await controller.signOut();
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),

      // 🧱 body: Sol menü + içerik
      body: Row(
        children: [
          // 🔹 Sol menü alanı
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 1, // tek sütun
                mainAxisSpacing: 12,
                childAspectRatio: 1, // kare şekil
                children: [
                  Buildmenubutton(
                    icon: Icons.inventory_2_outlined,
                    label: "Ürünler",
                    index: 0,
                  ),
                  Buildmenubutton(
                    icon: Icons.add_box_outlined,
                    label: "Ürün Ekle",
                    index: 1,
                  ),
                  Buildmenubutton(
                    icon: Icons.history_edu_outlined,
                    label: "Geçmiş",
                    index: 2,
                  ),
                  Buildmenubutton(
                    icon: Icons.favorite,
                    label: "Favoriler",
                    index: 3,
                  ),
                  Buildmenubutton(
                    icon: Icons.settings_outlined,
                    label: "Ayarlar",
                    index: 4,
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Orta alan (seçilen sayfa)
          Expanded(
            flex: 4,
            child: Obx(
              () => controller.buildPage(controller.currentIndex.value),
            ),
          ),

          // 🔹 Sağ taraf (Sepet)
          Expanded(flex: 4, child: const BasketPage()),
        ],
      ),
    );
  }
}
