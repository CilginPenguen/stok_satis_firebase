import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../history_controller.dart';

class HistoryExpansionTile extends GetView<HistoryController> {
  const HistoryExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final groupedData = controller.groupedSalesByDayAndHour;

        if (groupedData.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Henüz satış verisi yok."),
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: groupedData.keys.map((day) {
            final hoursMap = groupedData[day]!;

            // Günlük toplam
            final double dailyTotal = hoursMap.values
                .expand((items) => items)
                .fold(0.0, (sum, item) {
                  final satisOzeti = controller.satisOzetList.firstWhereOrNull(
                    (s) => s.satis_id == item.satis_id,
                  );

                  if (satisOzeti != null) {
                    return sum +
                        (satisOzeti.alinanTutar == satisOzeti.toplamTutar
                            ? satisOzeti.toplamTutar
                            : satisOzeti.alinanTutar);
                  } else {
                    return sum + item.toplam_tutar; // eşleşme yoksa fallback
                  }
                });

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("₺${dailyTotal.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
                children: hoursMap.keys.map((hour) {
                  final items = hoursMap[hour]!;

                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4, top: 4),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  hour,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "₺${items.fold(0.0, (sum, item) {
                                      final satisOzeti = controller.satisOzetList.firstWhereOrNull((s) => s.satis_id == item.satis_id);

                                      if (satisOzeti != null) {
                                        return sum + (satisOzeti.alinanTutar == satisOzeti.toplamTutar ? satisOzeti.toplamTutar : satisOzeti.alinanTutar);
                                      } else {
                                        return sum + item.toplam_tutar;
                                      }
                                    }).toStringAsFixed(2)}",
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Satıcı: ${controller.getSellerName(items)}",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Dismissible(
                                key: ValueKey(item.gecmis_id),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  await controller.deleteSale(item);
                                  return false;
                                },
                                background: Container(
                                  color: Colors.orange,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                ),
                                child: ListTile(
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
                                  trailing: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Adet: ${item.sepet_birim}"),
                                        Text(
                                          "Birim Fiyat : ₺${item.indirim > 0 ? (item.urun_fiyat * ((100 - item.indirim) / 100)).toStringAsFixed(2) : item.urun_fiyat.toStringAsFixed(2)}",
                                        ),
                                        Text(
                                          "Toplam : ₺${item.toplam_tutar.toStringAsFixed(2)} ",
                                        ),
                                        Visibility(
                                          visible: item.indirim > 0,
                                          child: Text(
                                            "İndirim: %${item.indirim}",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1, thickness: 1),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
