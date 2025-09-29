import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/gecmis_siparis.dart';
import '../history_controller.dart';

class HistoryExpansionTile extends GetView<HistoryController> {
  const HistoryExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final groupedData = controller.groupedSalesByDate;

        if (groupedData.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Henüz satış verisi yok."),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: groupedData.length,
          itemBuilder: (context, index) {
            final date = groupedData.keys.elementAt(index);
            final List<Gecmis> items = groupedData[date]!;

            // 🔹 Günlük toplam
            final double dailyTotal = items.fold(
              0.0,
              (sum, item) => sum + item.toplam_tutar,
            );

            // 🔹 Tarih kartı Dismissible
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
                      date,
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
                      child: Text(
                        "₺${dailyTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                children: items.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Bu tarihte veri yok."),
                        ),
                      ]
                    : items
                          .map(
                            (item) => Dismissible(
                              key: ValueKey(item.gecmis_id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                print(
                                  "gecmis_id: ${item.gecmis_id},urun_id:${item.urun_id}",
                                );
                                await controller.deleteSale(item);
                                return false; // dialog içinde handle edildi
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
                              ),
                            ),
                          )
                          .toList(),
              ),
            );
          },
        );
      }),
    );
  }
}
