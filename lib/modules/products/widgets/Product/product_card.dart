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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: GestureDetector(
        onTap: () => controller.urunDuzenleDiyalog(urun),
        child: ListTile(
          leading: const Icon(Icons.inventory_2),
          title: Text("${urun.marka} / ${urun.category}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible:
                    controller.isWindows() ||
                    Get.isRegistered<BasketController>(),
                child: Text("Stok: ${urun.urun_adet}"),
              ),
              Visibility(
                visible:
                    controller.isWindows() ||
                    Get.isRegistered<BasketController>(),
                child: Text("Fiyat: ₺${urun.urun_fiyat.toStringAsFixed(2)}"),
              ),
              Text("Açıklama: ${urun.urun_description}"),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ⭐ Sadece masaüstünde
              if (controller.isWindows())
                IconButton(
                  tooltip: urun.isFavorited
                      ? "Favoriden çıkar"
                      : "Favoriye ekle",
                  icon: Icon(
                    urun.isFavorited ? Icons.star : Icons.star_border,
                    color: urun.isFavorited ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => controller.updateFavorite(
                    uid: urun.urun_id,
                    isFavorited: !urun.isFavorited,
                  ),
                ),

              if (Get.isRegistered<BasketController>())
                Obx(() => _buildBasketControls())
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Adet: ${urun.urun_adet}"),
                    Text("Fiyat: ₺${urun.urun_fiyat.toStringAsFixed(2)}"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasketControls() {
    final basket = Get.find<BasketController>();
    final index = basket.basketList.indexWhere(
      (i) => i.urun_id == urun.urun_id,
    );
    if (index != -1) {
      final sepet = basket.basketList[index];
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (sepet.sepet_birim > 1) {
                sepet.sepet_birim--;
                basket.basketList.refresh();
              }
            },
          ),
          Text("${sepet.sepet_birim}"),
          IconButton(
            icon: const Icon(Icons.add),
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
        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
        label: const Text("Ekle"),
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
        },
      );
    }
  }
}
