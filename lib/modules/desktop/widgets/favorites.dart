import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/models/sepet_liste.dart';
import 'package:stok_satis_firebase/modules/desktop/desktop_controller.dart';
import '../../basket/basket_controller.dart';
import '../../products/product_controller.dart';

class FavoritesPage extends GetView<DesktopController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("⭐ Favoriler"),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final favList = productCtrl.favoriListe;

        if (favList.isEmpty) {
          return const Center(child: Text("Henüz favori ürün yok."));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.5,
                maxCrossAxisExtent: 260,
              ),
              itemBuilder: (context, i) {
                final urun = favList[i];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Üst Bilgi
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${urun.marka} / ${urun.category}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              tooltip: "Favoriden çıkar",
                              icon: const Icon(Icons.star, color: Colors.amber),
                              onPressed: () => controller.updateFavorite(
                                uid: urun.urun_id,
                                isFavorited: !urun.isFavorited,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        Text(
                          urun.urun_description,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),

                        const Spacer(),
                        Text(
                          "Adet: ${urun.urun_adet}",
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₺${urun.urun_fiyat.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            // 🔹 Sepet kontrolü reaktif hale getirildi
                            Obx(() => _buildBasketControls(urun)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildBasketControls(urun) {
    final basket = Get.find<BasketController>();
    final index = basket.basketList.indexWhere(
      (item) => item.urun_id == urun.urun_id,
    );

    if (index != -1) {
      final sepet = basket.basketList[index];
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () {
              if (sepet.sepet_birim > 1) {
                sepet.sepet_birim--;
              } else {
                basket.basketList.removeAt(index);
              }
              basket.basketList.refresh();
            },
          ),
          Text(
            "${sepet.sepet_birim}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () {
              if (sepet.sepet_birim < sepet.urun_adet) {
                sepet.sepet_birim++;
                basket.basketList.refresh();
              }
            },
          ),
        ],
      );
    } else {
      return OutlinedButton.icon(
        icon: const Icon(
          Icons.add_shopping_cart,
          color: Colors.green,
          size: 18,
        ),
        label: const Text("Ekle", style: TextStyle(fontSize: 11)),
        onPressed: () {
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
          basket.basketList.refresh();
        },
      );
    }
  }
}
