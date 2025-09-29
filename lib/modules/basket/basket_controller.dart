import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/base_controller.dart';
import '../../models/gecmis_siparis.dart';
import '../../models/sepet_liste.dart';
import '../history/history_controller.dart';
import '../home/home_controller.dart';
import '../products/product_controller.dart';

class BasketController extends BaseController {
  var basketList = <Sepet>[].obs;
  DateTime anlikTarih = DateTime.now();
  DateFormat tarihFormati = DateFormat("yyyy-MM-dd");

  bool sepetKontrol({required String id}) {
    return basketList.any((item) => item.urun_id == id);
  }

  double getAspectRatio(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 600) {
      return 0.85; // Küçük ekran: kart daha uzun
    } else if (screenHeight < 800) {
      return 1.1; // Orta ekran
    } else {
      return 1.35; // Büyük ekran
    }
  }

  Future<bool> sepetiOnayla() async {
    try {
      var gecmisYenile = Get.find<HistoryController>();
      var proCont = Get.find<ProductController>();
      final ownerUid = await bringOwnerUid();

      if (ownerUid != "") {
        for (var i in basketList) {
          double salary = i.urun_fiyat * i.sepet_birim;
          await proCont.alisverisStokGuncelle(
            i.urun_id,
            i.urun_adet - i.sepet_birim,
          );
          var gecmis = Gecmis(
            urun_id: i.urun_id,
            urun_description: i.urun_description,
            urun_adet: i.urun_adet,
            urun_fiyat: i.urun_fiyat,
            category: i.category,
            sepet_birim: i.sepet_birim,
            toplam_tutar: salary,
            tarih: tarihFormati.format(anlikTarih),
            urun_barkod: i.urun_barkod,
            marka: i.marka,
          );
          await db
              .collection("users")
              .doc(ownerUid)
              .collection("gecmis")
              .add(gecmis.toMap());
        }
        await gecmisYenile.gecmisGetir();
        gecmisYenile.dailyIncome;
        gecmisYenile.monthlyIncome;
        basketList.clear();
        return true;
      }
      showErrorSnackbar(message: "Kullanıcı tarafında hata");
      return false;
    } on Exception catch (e) {
      print(e);
      showErrorSnackbar(message: "Bir hata oluştu: $e");
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    final home = Get.find<HomeController>();
    if (home.backupBasketList.isNotEmpty) {
      basketList.assignAll(home.backupBasketList);
    }
  }

  Future<void> saveBasket() async {
    final l = Get.find<HomeController>();
    await alertDiyalog(
      title: "Sepet Kaydedilsin Mi?",
      widgets: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              l.backupBasketList.value = basketList;
              Get.back(closeOverlays: true);
            },
            label: Text("Evet"),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Get.back(closeOverlays: true);
              if (l.backupBasketList.isNotEmpty) {
                l.backupBasketList.clear();
              }
            },
            label: Text("Hayır"),
          ),
        ],
      ),
    );
  }
}
