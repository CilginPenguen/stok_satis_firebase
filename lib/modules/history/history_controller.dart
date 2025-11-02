import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stok_satis_firebase/models/satis_ozet.dart';

import '../../core/base_controller.dart';
import '../../models/gecmis_siparis.dart';
import '../products/product_controller.dart';

class HistoryController extends BaseController {
  final gecmisList = <Gecmis>[].obs;
  final satisOzetList = <SatisOzeti>[].obs;
  final dailyIncome = 0.0.obs;
  final monthlyIncome = 0.0.obs;

  /// Geçmiş verilerini getir
  Future<void> gecmisGetir() async {
    try {
      final ownerUid = await bringOwnerUid();
      if (ownerUid != "") {
        if (checkOwner()) {
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
                _updateIncomes();
              });
        } else {
          final isim = await bringNameAndSurname();
          db
              .collection("users")
              .doc(ownerUid)
              .collection("gecmis")
              .snapshots()
              .listen((snapshot) {
                final gecmisVeri = snapshot.docs
                    .map((doc) => Gecmis.fromMap(doc.data(), docId: doc.id))
                    .where((item) => item.satisYapan == isim)
                    .toList();
                gecmisList.value = gecmisVeri;
                _updateIncomes();
              });
        }
        db
            .collection("users")
            .doc(ownerUid)
            .collection("satisOzeti")
            .snapshots()
            .listen((snapshot) {
              final satislar = snapshot.docs.map((e) {
                return SatisOzeti.fromMap(e.data());
              }).toList();
              satisOzetList.value = satislar;
              print(satisOzetList);
              _updateIncomes();
            });
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Geçmiş getirilirken hata oluştu: $e");
    }
  }

  void _updateIncomes() {
    if (gecmisList.isEmpty) {
      dailyIncome.value = 0.0;
      monthlyIncome.value = 0.0;
      return;
    }

    final today = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final currentMonth = DateFormat('MM.yyyy').format(DateTime.now());

    double daily = 0.0;
    double monthly = 0.0;

    for (var e in gecmisList) {
      final kayitTarihi = e.tarih.split(' ').first;

      final satisOzeti = satisOzetList.firstWhereOrNull(
        (s) => s.satis_id.toString() == e.satis_id.toString(),
      );

      double tutar = satisOzeti != null
          ? (satisOzeti.alinanTutar == satisOzeti.toplamTutar
                ? satisOzeti.toplamTutar
                : satisOzeti.alinanTutar)
          : e.toplam_tutar;

      if (kayitTarihi == today) daily += tutar;
      if (kayitTarihi.endsWith(currentMonth)) monthly += tutar;
    }

    dailyIncome.value = daily;
    monthlyIncome.value = monthly;
  }

  String getSellerName(List<Gecmis> items) {
    final sellers = items
        .map((e) => e.satisYapan)
        .where((e) => e.isNotEmpty)
        .toSet();
    if (sellers.isEmpty) return "Bilinmiyor";
    if (sellers.length == 1) return sellers.first;
    return sellers.join(", ");
  }

  /// Sadece bugünün verisi
  List<Gecmis> get todaysData {
    final today = DateFormat('dd.MM.yyyy').format(DateTime.now());
    return gecmisList.where((item) => item.tarih.startsWith(today)).toList();
  }

  /// Tarih bazlı gruplama
  // Gün ve saat bazlı gruplama
  Map<String, Map<String, List<Gecmis>>> get groupedSalesByDayAndHour {
    final Map<String, Map<String, List<Gecmis>>> grouped = {};

    for (var item in gecmisList) {
      // Tarihi DateTime'a çevir
      final dateTime = DateFormat("dd.MM.yyyy HH:mm").parse(item.tarih);

      // Gün ve saat key'leri
      final dayKey = DateFormat("dd.MM.yyyy").format(dateTime);
      final hourKey = DateFormat("HH:mm").format(dateTime);

      // Map oluştur
      grouped.putIfAbsent(dayKey, () => {});
      grouped[dayKey]!.putIfAbsent(hourKey, () => []);
      grouped[dayKey]![hourKey]!.add(item);
    }

    // Günleri büyükten küçüğe sırala
    final sortedDays = grouped.keys.toList()
      ..sort(
        (a, b) => DateFormat(
          "dd.MM.yyyy",
        ).parse(b).compareTo(DateFormat("dd.MM.yyyy").parse(a)),
      );

    final Map<String, Map<String, List<Gecmis>>> sortedGrouped = {};
    for (var day in sortedDays) {
      // Saatleri küçükten büyüğe sırala
      final hoursMap = grouped[day]!;
      final sortedHours = hoursMap.keys.toList()
        ..sort(
          (a, b) => DateFormat(
            "HH:mm",
          ).parse(a).compareTo(DateFormat("HH:mm").parse(b)),
        );

      sortedGrouped[day] = {for (var h in sortedHours) h: hoursMap[h]!};
    }

    return sortedGrouped;
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

  /// Bugünün saat bazlı satışları
  Map<String, List<Gecmis>> get todaysGroupedByHour {
    final todayKey = DateFormat("dd.MM.yyyy").format(DateTime.now());
    return groupedSalesByDayAndHour[todayKey] ?? {};
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
