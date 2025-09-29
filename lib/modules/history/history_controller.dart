import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/base_controller.dart';
import '../../models/gecmis_siparis.dart';
import '../products/product_controller.dart';

class HistoryController extends BaseController {
  final gecmisList = <Gecmis>[].obs;

  /// Geçmiş verilerini getir
  Future<void> gecmisGetir() async {
    try {
      final ownerUid = await bringOwnerUid();
      if (ownerUid != "") {
        db
            .collection("users")
            .doc(ownerUid)
            .collection("gecmis")
            .snapshots()
            .listen((snapshot) {
              final gecmisVeri = snapshot.docs.map((doc) {
                return Gecmis.fromMap(doc.data(), docId: doc.id);
              }).toList();
              gecmisList.value = gecmisVeri;
            });
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Geçmiş getirilirken hata oluştu: $e");
    }
  }

  /// Günlük toplam
  double get dailyIncome {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return gecmisList
        .where((e) => e.tarih == today)
        .fold(0.0, (sum, e) => sum + e.toplam_tutar);
  }

  /// Aylık toplam
  double get monthlyIncome {
    final now = DateTime.now();
    final currentMonth = DateFormat('yyyy-MM').format(now);
    return gecmisList
        .where((e) => e.tarih.startsWith(currentMonth))
        .fold(0.0, (sum, e) => sum + e.toplam_tutar);
  }

  /// Sadece bugünün verisi
  List<Gecmis> get todaysData {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return gecmisList.where((item) => item.tarih == today).toList();
  }

  /// Tarih bazlı gruplama
  Map<String, List<Gecmis>> get groupedSalesByDate {
    final Map<String, List<Gecmis>> grouped = {};

    for (var item in gecmisList) {
      final date = item.tarih; // zaten "yyyy-MM-dd" string geliyor
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }

    // Tarihleri büyükten küçüğe sırala (yeni tarih en üstte)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  /// 🔹 Tek kaydı sil
  Future<void> deleteSale(Gecmis item) async {
    final ownerUid = await bringOwnerUid();
    final l = Get.find<ProductController>();
    await l.urunleriGetir();
    try {
      if (ownerUid != "") {
        await alertDiyalog(
          title: "Onay",
          widgets: Row(
            children: [
              TextButton(
                onPressed: () => Get.back(), // vazgeç
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () async {
                  var c = Get.find<ProductController>();
                  print(item.gecmis_id);
                  print(item.urun_id);
                  c.gecmisStokGuncelle(
                    urunID: item.urun_id,
                    gecmisAdet: item.sepet_birim,
                  );
                  Get.back();
                  await db
                      .collection("users")
                      .doc(ownerUid)
                      .collection("gecmis")
                      .doc(item.gecmis_id)
                      .delete();

                  gecmisList.remove(item);
                  showSuccessSnackbar(message: "Kayıt başarıyla silindi.");
                },
                child: const Text("Sil", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      } else {
        showErrorSnackbar(message: "Hesap bilgisinde hata");
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Geçmişi Silerken Hata Oluştu $e");
    }
  }

  ///  Tarihe ait tüm kayıtları sil
  // Future<void> deleteSalesByDate(String date) async {
  //   final ownerUid = await bringOwnerUid();
  //   try {
  //     if (ownerUid != "") {
  //       await alertDiyalog(
  //         title: "Onay",
  //         widgets: Row(
  //           children: [
  //             TextButton(
  //               onPressed: () => Get.back(),
  //               child: const Text("İptal"),
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //                 final query = await db
  //                     .collection("users")
  //                     .doc(ownerUid)
  //                     .collection("gecmis")
  //                     .where("tarih", isEqualTo: date)
  //                     .get();

  //                 for (var doc in query.docs) {
  //                   await doc.reference.delete();
  //                 }

  //                 // Local listedeki verileri de temizle
  //                 gecmisList.removeWhere((e) => e.tarih == date);

  //                 Get.back();
  //                 showSuccessSnackbar(
  //                   message: "$date tarihli tüm kayıtlar silindi.",
  //                 );
  //               },
  //               child: const Text(
  //                 "Hepsini Sil",
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       showErrorSnackbar(message: "Hesap bilgisinde hata");
  //     }
  //   } on Exception catch (e) {
  //     showErrorSnackbar(message: "Geçmişi silerken hata oluştu");
  //   }
  // }
}
