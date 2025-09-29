import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/sepet_liste.dart';
import '../../../../models/urunler_liste.dart';
import '../../../basket/basket_controller.dart';
import '../../product_controller.dart';

class ProductCard extends GetView<ProductController> {
  final Urunler urun;

  const ProductCard({required this.urun, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.urunDuzenleDiyalog(urun),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.inventory_2),
          title: Text("${urun.marka}/${urun.category}"),
          subtitle: Get.isRegistered<BasketController>()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mevcut => ${urun.urun_adet}"),
                    Text(
                      "Birim Fiyat => ${urun.urun_fiyat.toStringAsFixed(2)}",
                    ),
                    Text("Detay => ${urun.urun_description}"),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Barkod: ${urun.urun_barkod}"),
                    Text("Tanım: ${urun.urun_description}"),
                  ],
                ),
          trailing: Get.isRegistered<BasketController>()
              ? Obx(() {
                  final basketController = Get.find<BasketController>();
                  final index = basketController.basketList.indexWhere(
                    (item) => item.urun_id == urun.urun_id,
                  );
                  final urunSepetteVarMi = index != -1;

                  if (urunSepetteVarMi) {
                    final sepet = basketController.basketList[index];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (sepet.sepet_birim > 1) {
                              sepet.sepet_birim--;
                              basketController.basketList.refresh();
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
                            if (sepet.sepet_birim < sepet.urun_adet) {
                              sepet.sepet_birim++;
                              basketController.basketList.refresh();
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    );
                  } else {
                    return OutlinedButton.icon(
                      label: const Text("Ekle"),
                      onPressed: () {
                        basketController.basketList.add(
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
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.green,
                      ),
                    );
                  }
                })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Adet: ${urun.urun_adet}"),
                    Text("₺${urun.urun_fiyat.toStringAsFixed(2)}"),
                  ],
                ),
        ),
      ),
    );
  }
}
