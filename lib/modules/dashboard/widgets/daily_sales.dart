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
        // 🔹 Sadece bugünün saatlik grupları
        final todayGroups = controller.hc.todaysGroupedByHour;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Column(
            children: [
              // 🔹 Başlık alanı
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
                        isExpanded ? "Kapat" : "Bugünkü Satışlar",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

              // 🔹 İçerik kısmı
              if (isExpanded)
                todayGroups.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Bugüne ait satış bulunamadı.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: todayGroups.keys.map((hour) {
                            final items = todayGroups[hour]!;

                            // 🔹 O saate ait toplam tutar
                            final double hourTotal = items.fold(0.0, (
                              sum,
                              item,
                            ) {
                              final satisOzeti = controller.hc.satisOzetList
                                  .firstWhereOrNull(
                                    (s) => s.satis_id == item.satis_id,
                                  );
                              if (satisOzeti != null) {
                                return sum +
                                    (satisOzeti.alinanTutar ==
                                            satisOzeti.toplamTutar
                                        ? satisOzeti.toplamTutar
                                        : satisOzeti.alinanTutar);
                              } else {
                                return sum + item.toplam_tutar;
                              }
                            });

                            // 🔹 Her saat için alt gruplama
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hour,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          controller.hc.getSellerName(items),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "₺${hourTotal.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.shopping_cart,
                                          color: Colors.green,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Kategori: ${item.category}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Marka: ${item.marka}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          "Açıklama: ${item.urun_description}",
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("Adet: ${item.sepet_birim}"),
                                            Text(
                                              "Birim: ₺${item.urun_fiyat.toStringAsFixed(2)}",
                                            ),
                                            Text(
                                              "Toplam: ₺${item.toplam_tutar.toStringAsFixed(2)}",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
            ],
          ),
        );
      }),
    );
  }
}
