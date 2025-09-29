import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';
import '../products/widgets/Product/barcode_scanner.dart';
import '../products/products_V2.dart';
import 'basket_controller.dart';

class BasketPage extends GetView<BasketController> {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (controller.basketList.isNotEmpty) {
          await controller.saveBasket();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () async {
              if (controller.basketList.isNotEmpty) {
                await controller.saveBasket();
              } else {
                Get.back();
              }
            },
          ),
          title: const Text("Sepet"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const ProductByCategoryPage());
              },
              icon: const Icon(Icons.add_shopping_cart),
            ),
            IconButton(
              onPressed: () async {
                if (controller.basketList.isNotEmpty) {
                  await controller.saveBasket();
                } else {
                  Get.back();
                }
              },
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.basketList.isEmpty) {
            return const Center(child: Text("Sepet Boş"));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.basketList.length,
              itemBuilder: (context, index) {
                final sepet = controller.basketList[index];
                String kusurengel = (sepet.urun_fiyat * sepet.sepet_birim)
                    .toStringAsFixed(2);
                double urunToplamFiyat = double.parse(kusurengel);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sepet.category,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Marka: ${sepet.marka}"),
                              const SizedBox(height: 2),
                              Text("Açıklama: ${sepet.urun_description}"),
                              const SizedBox(height: 8),
                              Text(
                                "Fiyat : $urunToplamFiyat ₺",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Birim Fiyatı: ${sepet.urun_fiyat} ₺',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (controller.basketList[index].sepet_birim >
                                    1) {
                                  controller.basketList[index].sepet_birim--;
                                  controller.basketList.refresh();
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Column(
                              children: [
                                Text("Adet: ${sepet.sepet_birim}"),
                                Text("Stok: ${sepet.urun_adet}"),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                if (controller.basketList[index].sepet_birim <
                                    controller.basketList[index].urun_adet) {
                                  controller.basketList[index].sepet_birim++;
                                  controller.basketList.refresh();
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            controller.basketList.removeAt(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
        bottomNavigationBar: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.darkTiffanyBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(125),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Toplam",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      "${controller.basketList.fold<double>(0, (sum, item) => sum + (item.urun_fiyat * item.sepet_birim)).toStringAsFixed(2)} ₺",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Get.to(BarcodeScanner(mod: 3)),
                      icon: const Icon(Icons.barcode_reader, size: 20),
                      label: const Text("Ekle"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Visibility(
                      visible: (controller.basketList.isNotEmpty),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          bool sonuc = await controller.sepetiOnayla();
                          if (sonuc) {
                            Get.back(canPop: true);

                            controller.showSuccessSnackbar(
                              message: "Alışveriş Tamamlandı",
                            );
                          }
                        },
                        icon: const Icon(Icons.done_all, size: 20),
                        label: const Text(" Tamamla"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
