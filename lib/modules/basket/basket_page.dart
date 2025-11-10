import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/app_colors.dart';
import '../products/products_V2.dart';
import '../products/widgets/Product/barcode_scanner.dart';
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
          leading: Visibility(
            visible: !controller.isWindows(),
            child: BackButton(
              onPressed: () async {
                if (controller.basketList.isNotEmpty) {
                  await controller.saveBasket();
                } else {
                  Get.back();
                }
              },
            ),
          ),
          title: const Text("Sepet"),
          actions: [
            Obx(() {
              if (controller.indirimModu.value) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => controller.indirimModu.value = false,
                      icon: Icon(Icons.cancel, color: Colors.red),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        controller.tumu.value = !controller.tumu.value;
                        await controller.tumuDurum();
                      },
                      child: controller.tumu.value
                          ? Text("Hepsi Iptal")
                          : Text("Hepsini Seç"),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await controller.secilenIndirimAyarla();
                      },
                      child: const Text("İndirim Ayarla"),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: controller.basketList.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          controller.elleTutarAyarla();
                        },
                        tooltip: "Alınan Tutarı Gir",
                        icon: const Icon(Icons.payments_outlined),
                      ),
                    ),
                    Visibility(
                      visible: controller.basketList.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          controller.indirimModu.value = true;
                        },
                        tooltip: "İndirim Ayarla",
                        icon: const Icon(Icons.percent),
                      ),
                    ),
                    Visibility(
                      visible: !controller.isWindows(),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => const ProductByCategoryPage());
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                      ),
                    ),
                    Visibility(
                      visible: !controller.isWindows(),
                      child: IconButton(
                        onPressed: () async {
                          if (controller.basketList.isNotEmpty) {
                            await controller.saveBasket();
                          } else {
                            Get.back();
                          }
                        },
                        icon: const Icon(Icons.home),
                      ),
                    ),
                  ],
                );
              }
            }),
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
                                sepet.indirim > 0
                                    ? "Fiyat:${(urunToplamFiyat * ((100 - sepet.indirim) / 100)).toStringAsFixed(2)} "
                                    : "Fiyat: $urunToplamFiyat ₺",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                sepet.indirim > 0
                                    ? "Fiyat:${(sepet.urun_fiyat * ((100 - sepet.indirim) / 100)).toStringAsFixed(2)} "
                                    : "Fiyat: ${sepet.urun_fiyat} ₺",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (controller
                                            .basketList[index]
                                            .sepet_birim >
                                        1) {
                                      controller
                                          .basketList[index]
                                          .sepet_birim--;
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
                                    if (controller
                                            .basketList[index]
                                            .sepet_birim <
                                        controller
                                            .basketList[index]
                                            .urun_adet) {
                                      controller
                                          .basketList[index]
                                          .sepet_birim++;
                                      controller.basketList.refresh();
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: sepet.indirim > 0,
                              child: Text("İndirim: %${sepet.indirim}"),
                            ),
                          ],
                        ),
                        Obx(() {
                          return controller.indirimModu.value
                              ? Checkbox(
                                  value: sepet.secilme,
                                  onChanged: (value) {
                                    sepet.secilme = value!;
                                    controller.basketList
                                        .refresh(); // listeyi refresh et ki UI güncellensin
                                  },
                                )
                              : IconButton(
                                  onPressed: () {
                                    controller.basketList.removeAt(index);
                                  },
                                  icon: const Icon(Icons.delete),
                                );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
        bottomNavigationBar: Obx(
          () => Material(
            elevation: 12,
            color: AppColors.darkTiffanyBlue,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        "${controller.toplamHesapla().toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: controller.hepsiIndirimliMi(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "İndirim: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "%${controller.indirimOran.value}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Visibility(
                          visible:
                              controller.manuelTutarDegeri.value.isNotEmpty &&
                              controller.manuelTutarDegeri.value != "0.00" &&
                              controller.basketList.isNotEmpty &&
                              controller.manuelTutarDegeri.value != "0" &&
                              controller.manuelTutarDegeri.value != "0.0",
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Alınacak:"),
                              Text("${controller.manuelTutarDegeri.value} ₺"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: !controller.isWindows(),
                        child: OutlinedButton.icon(
                          onPressed: () => Get.to(BarcodeScanner(mod: 3)),
                          icon: const Icon(Icons.barcode_reader, size: 20),
                          label: const Text("Ekle"),
                        ),
                      ),
                      SizedBox(width: 5),
                      OutlinedButton.icon(
                        onPressed: () async {
                          if (!controller.isWindows()) {
                            Get.back();
                          }
                          await controller.sepetiOnayla();
                        },
                        icon: const Icon(Icons.done_all),
                        label: const Text("Tamamla"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
