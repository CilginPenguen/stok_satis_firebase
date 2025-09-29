import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../models/sepet_liste.dart';
import '../../../basket/basket_controller.dart';
import '../../product_controller.dart';

class BarcodeScanner extends GetView<ProductController> {
  final int mod; // 1 = düzenleme, 2 = ekleme, 3 = sürekli tarama

  const BarcodeScanner({super.key, required this.mod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Kamera görüntüsü
          MobileScanner(
            controller: controller.barkodController,
            onDetect: (capture) async {
              if (capture.barcodes.isNotEmpty) {
                final barcode = capture.barcodes.first;
                if (barcode.format == BarcodeFormat.qrCode) return;

                final okunanBarkod = capture.barcodes.first.rawValue;
                if (okunanBarkod != null) {
                  switch (mod) {
                    case 1:
                      controller.barkodUrunArama(okunanBarkod);
                      break;
                    case 2:
                      controller.setBarkod(okunanBarkod);
                      await controller.barkodController.stop();
                      await Future.delayed(const Duration(milliseconds: 200));
                      Get.back();
                      break;
                    case 3:
                      if (Get.isRegistered<BasketController>()) {
                        final basket = Get.find<BasketController>();
                        final urun = controller.urunListesi.firstWhereOrNull(
                          (u) => u.urun_barkod == okunanBarkod,
                        );
                        if (urun != null) {
                          final mevcut = basket.basketList.firstWhereOrNull(
                            (s) => s.urun_id == urun.urun_id,
                          );
                          if (mevcut == null) {
                            basket.basketList.add(
                              Sepet(
                                urun_id: urun.urun_id,
                                urun_barkod: urun.urun_barkod,
                                urun_description: urun.urun_description,
                                urun_adet: urun.urun_adet,
                                urun_fiyat: urun.urun_fiyat,
                                sepet_birim: 1,
                                ilkToplam: urun.urun_fiyat,
                                category: urun.category,
                                marka: urun.marka,
                              ),
                            );
                          }
                        } else {
                          controller.showErrorSnackbar(
                            message:
                                "Barkod $okunanBarkod için eşleşen ürün bulunamadı!",
                          );
                        }
                      }
                      break;
                  }
                }
              }
            },
          ),

          /// Geri butonu
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  await controller.barkodController.stop();
                  Get.back();
                },
              ),
            ),
          ),

          /// Flash butonu
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.flash_on, color: Colors.white),
                onPressed: () {
                  controller.barkodController.toggleTorch();
                },
              ),
            ),
          ),

          /// Kamera değiştirme butonu
          Positioned(
            top: 40,
            right: 70,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.cameraswitch, color: Colors.white),
                onPressed: () {
                  controller.barkodController.switchCamera();
                },
              ),
            ),
          ),

          /// Sürekli tarama alt liste
          if (mod == 3)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withAlpha(170),
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Obx(() {
                        final basket = Get.find<BasketController>();
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                childAspectRatio: basket.getAspectRatio(
                                  context,
                                ),
                              ),
                          itemCount: basket.basketList.length,
                          itemBuilder: (context, index) {
                            final urun = basket.basketList[index];
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kategori: ${urun.category}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Marka: ${urun.marka}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    urun.urun_description,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Toplam: ${urun.urun_fiyat * urun.sepet_birim} ₺",
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (urun.sepet_birim > 1) {
                                            urun.sepet_birim--;
                                            basket.basketList.refresh();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Adet: ${urun.sepet_birim}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Stok: ${urun.urun_adet}",
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (urun.sepet_birim <
                                              urun.urun_adet) {
                                            urun.sepet_birim++;
                                            basket.basketList.refresh();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size.fromHeight(45),
                        ),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          "Taramayı Tamamla",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await controller.barkodController.stop();
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
