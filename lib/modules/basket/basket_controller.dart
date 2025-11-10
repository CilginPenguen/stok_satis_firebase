import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:stok_satis_firebase/models/satis_ozet.dart';

import '../../core/base_controller.dart';
import '../../models/gecmis_siparis.dart';
import '../../models/sepet_liste.dart';
import '../history/history_controller.dart';
import '../home/home_controller.dart';
import '../products/product_controller.dart';

class BasketController extends BaseController {
  var basketList = <Sepet>[].obs;
  DateTime anlikTarih = DateTime.now();
  DateFormat tarihFormati = DateFormat("dd.MM.yyyy HH:mm");
  var manuelDegerEkle = false.obs;
  final manuelTutar = TextEditingController();
  var indirimModu = false.obs;
  var tumu = false.obs;
  RxDouble toplam = 0.0.obs;
  RxInt indirimOran = 0.obs;
  RxString manuelTutarDegeri = ''.obs;

  // 🔹 Barkoddan ürünü bulup sepete ekle
  void processBarcode(String barcode) {
    final productController = Get.find<ProductController>();
    final product = productController.urunListesi.firstWhereOrNull(
      (e) => e.urun_barkod == barcode,
    );

    if (product == null) {
      Get.snackbar("Ürün bulunamadı", "Barkod: $barcode");
      return;
    }

    final index = basketList.indexWhere(
      (item) => item.urun_id == product.urun_id,
    );

    if (index != -1) {
      basketList[index].sepet_birim++;
      basketList.refresh();
    } else {
      basketList.add(
        Sepet(
          urun_id: product.urun_id,
          urun_barkod: product.urun_barkod,
          urun_description: product.urun_description,
          urun_adet: product.urun_adet,
          urun_fiyat: product.urun_fiyat,
          sepet_birim: 1,
          ilkToplam: product.urun_fiyat,
          category: product.category,
          marka: product.marka,
        ),
      );
    }

    Get.snackbar(
      "Sepete Eklendi",
      "${product.marka} / ${product.urun_description}",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

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
      double toplamSatis = 0;
      String satisId = DateTime.now().millisecondsSinceEpoch.toString();

      if (ownerUid != "") {
        String satan = await bringNameAndSurname();
        for (var i in basketList) {
          double salary = i.urun_fiyat * i.sepet_birim;
          if (i.indirim > 0) {
            salary = salary * ((100 - i.indirim) / 100);
            toplamSatis += salary;
          } else {
            toplamSatis += salary;
          }
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
            satisYapan: satan,
            indirim: i.indirim,
            satis_id: satisId,
          );
          await db
              .collection("users")
              .doc(ownerUid)
              .collection("gecmis")
              .add(gecmis.toMap());
        }
        double? alinanPara = double.tryParse(manuelTutar.text.trim());
        if (alinanPara == null || alinanPara <= 0) {
          alinanPara = toplamSatis;
        }
        await db
            .collection("users")
            .doc(ownerUid)
            .collection("satisOzeti")
            .doc(satisId)
            .set(
              SatisOzeti(
                satis_id: satisId,
                toplamTutar: toplamSatis,
                alinanTutar: alinanPara,
                tarih: tarihFormati.format(anlikTarih),
              ).toMap(),
            );

        await gecmisYenile.gecmisGetir();
        gecmisYenile.dailyIncome;
        gecmisYenile.monthlyIncome;
        basketList.clear();
        manuelTutarDegeri.value = "0.0";
        indirimOran.value = 0;
        manuelTutar.clear();
        showSuccessSnackbar(message: "Alışveriş Tamamlandı");
        return true;
      }
      showErrorSnackbar(message: "Kullanıcı tarafında hata");
      return false;
    } on Exception catch (e) {
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
    manuelTutar.addListener(() {
      manuelTutarDegeri.value = manuelTutar.text;
    });
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

  Future<void> secilenIndirimAyarla() async {
    RxInt secilenOran = 0.obs;
    FixedExtentScrollController scrollController = FixedExtentScrollController(
      initialItem: 0,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Lütfen yapmak istediğiniz indirim yüzdesini ayarlayınız.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 0–99 arası kaydırılabilir liste
              SizedBox(
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  controller: scrollController,
                  itemExtent: 40,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    secilenOran.value = index;
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index > 99) return null;
                      return Center(
                        child: Text(
                          "$index%",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Obx(
                () => Text(
                  "Seçilen: %${secilenOran.value}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                      indirimModu.value = F;
                    }, // iptal
                    child: const Text("İptal"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await indirimAyarla(secilenOran.value);
                      Get.back();
                    },
                    child: const Text("Onayla"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> indirimAyarla(int indirim) async {
    for (var a in basketList) {
      if (a.secilme) {
        a.indirim = indirim;
        a.secilme = !a.secilme;
      }
    }
    basketList.refresh();
    toplamHesapla();
    indirimOran.value = indirim;
    indirimModu.value = F;
    tumu.value = F;
  }

  Future<void> tumuDurum() async {
    for (var i in basketList) {
      i.secilme = !i.secilme;
    }
    basketList.refresh();
  }

  double toplamHesapla() {
    double yeniToplam = 0; // geçici değişken
    for (var i in basketList) {
      if (i.indirim > 0) {
        yeniToplam +=
            (i.sepet_birim * i.urun_fiyat) * ((100 - i.indirim) / 100);
      } else {
        yeniToplam += i.sepet_birim * i.urun_fiyat;
      }
    }

    return toplam.value = yeniToplam; // reaktif değişimi burada yap
  }

  bool hepsiIndirimliMi() {
    if (basketList.isEmpty) return false;

    final ilkIndirim = basketList.first.indirim;
    if (basketList.every((b) => b.indirim == 0)) return false;

    final hepsiAyni = basketList.every((a) => a.indirim == ilkIndirim);

    indirimOran.value = hepsiAyni ? ilkIndirim : 0;

    return hepsiAyni;
  }

  Future<void> elleTutarAyarla() async {
    final tutarRegex = RegExp(r'^\d{0,5}([.,]\d{0,2})?$');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Alınan Tutarı Giriniz",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: manuelTutar,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Örnek: 125.50",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // 🔹 Hatalı karakter girişini engelle
                  if (!tutarRegex.hasMatch(value)) {
                    // Geçersiz karakter girildiyse geri al
                    manuelTutar.text = value.isNotEmpty
                        ? value.substring(0, value.length - 1)
                        : "";
                    manuelTutar.selection = TextSelection.fromPosition(
                      TextPosition(offset: manuelTutar.text.length),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("İptal"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                      // 🔹 Değeri formatla
                      final text = manuelTutar.text.trim().replaceAll(',', '.');
                      if (text.isNotEmpty) {
                        double? value = double.tryParse(text);
                        if (value != null) {
                          manuelTutar.text = value.toStringAsFixed(2);
                        }
                      }
                    },
                    child: const Text("Onayla"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
