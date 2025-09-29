import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard_controller.dart';

class DailySales extends GetView<DashboardController> {
  const DailySales({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final isExpanded = controller.isExpanded.value;
        final data = controller.hc.todaysData;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  controller.isExpanded.toggle();
                },
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isExpanded ? " Kapat" : "Bugünki Satışlar",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded) const Divider(height: 0),
              if (isExpanded)
                data.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Bugüne ait veri yok.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return ListTile(
                            leading: const Icon(
                              Icons.shopping_cart,
                              color: Colors.green,
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kategori: ${item.category}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Marka: ${item.marka}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Açıklama: ${item.urun_description}"),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Adet: ${item.sepet_birim}"),
                                Text(
                                  "Birim Fiyat : ₺${item.urun_fiyat.toStringAsFixed(2)}",
                                ),
                                Text(
                                  "Toplam : ₺${item.toplam_tutar.toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ],
          ),
        );
      }),
    );
  }
}
