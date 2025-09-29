import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';
import '../../../themes/app_colors.dart';
import '../basket_controller.dart';

class BottomBar extends GetView<BasketController> {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Obx(
                () => Text(
                  "${controller.basketList.fold<double>(0, (sum, item) => sum + (item.urun_fiyat * item.sepet_birim)).toStringAsFixed(2)} ₺",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: (controller.basketList.isNotEmpty),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.barcode_reader, size: 20),
                  label: const Text("Tara"),
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
                OutlinedButton.icon(
                  onPressed: () async {
                    if (controller.basketList.isNotEmpty) {
                      bool result = await controller.sepetiOnayla();
                      if (result) {
                        Get.offNamedUntil(
                          AppRoutes.home,
                          (route) => route.settings.name == AppRoutes.home,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.done_all, size: 20),
                  label: const Text("Sepeti Tamamla"),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
