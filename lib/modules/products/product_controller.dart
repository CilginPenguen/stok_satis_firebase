import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/base_controller.dart';
import '../../models/urunler_liste.dart';
import 'widgets/AddProduct/product_barcode.dart';
import 'widgets/AddProduct/product_brand.dart';
import 'widgets/AddProduct/product_category.dart';
import 'widgets/AddProduct/product_count.dart';
import 'widgets/AddProduct/product_description.dart';
import 'widgets/AddProduct/product_price.dart';
import 'widgets/AddProduct/save_button.dart';
import 'widgets/Product/info_row.dart';

class ProductController extends BaseController {
  var urunListesi = <Urunler>[].obs;
  var aktifSayfa = 1.obs;
  final barkodTextController = TextEditingController();
  final productCountTextController = TextEditingController();
  final productDescriptionTextController = TextEditingController();
  final productPriceTextController = TextEditingController();
  final productCategoryTextController = TextEditingController();
  final productMarkaTextController = TextEditingController();

  RxMap<String, String> selectedDescription = <String, String>{}.obs;
  RxMap<String, String> selectedBrand = <String, String>{}.obs;

  final searchProduct = "".obs;
  final urunBarkod = "".obs;
  final urunDescription = "".obs;
  final urunAdet = 0.obs;
  final urunFiyat = 0.0.obs;
  final kategori = "".obs;
  final marka = "".obs;
  final formKey = GlobalKey<FormState>();
  var isSearching = false.obs;
  final urunGuncelleme = false.obs;

  Future<void> urunDuzenleDiyalog(Urunler uruns) async {
    bool checkperm = await checkPermission(permissionName: "editProduct");

    if (checkperm) {
      urunBarkod.value = uruns.urun_barkod;
      barkodTextController.text = uruns.urun_barkod;
      urunDescription.value = uruns.urun_description;
      productDescriptionTextController.text = uruns.urun_description;
      productCategoryTextController.text = uruns.category;
      productMarkaTextController.text = uruns.marka;
      kategori.value = uruns.category;
      marka.value = uruns.marka;

      urunAdet.value = uruns.urun_adet;
      productCountTextController.text = uruns.urun_adet.toString();

      urunFiyat.value = uruns.urun_fiyat;
      productPriceTextController.text = uruns.urun_fiyat.toString();

      urunGuncelleme.value = true;

      await diyalog(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProductBarcode(),
                  const SizedBox(height: 10),
                  ProductBrand(),
                  const SizedBox(height: 10),
                  ProductCategory(),
                  const SizedBox(height: 10),
                  const ProductDescription(),
                  const SizedBox(height: 10),
                  const ProductCount(),
                  const SizedBox(height: 10),
                  const ProductPrice(),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  SaveButton(urunId: uruns.urun_id),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (!checkperm) {
      showErrorSnackbar(message: "Yetkiniz Bulunmamaktadır");
    }
  }

  // void toggleSearch() {
  //   if (isSearching.value) {
  //     searchProduct.value = "";
  //   }
  //   isSearching.value = !isSearching.value;
  // }

  Future<bool> silDiyalog({required Urunler item}) async {
    bool checkperm = await checkPermission(permissionName: "deleteProduct");
    if (checkperm) {
      final sonuc = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Silmek İstediğinize Emin Misiniz?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow("Kategori", item.category),
              InfoRow("Ürün Markası", item.marka),
              InfoRow("Urun Açıklaması", item.urun_description),
              InfoRow("Ürün Adedi", item.urun_adet.toString()),
              InfoRow("Ürün Fiyatı", item.urun_fiyat.toString()),
              InfoRow("Ürün Barkod", item.urun_barkod),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(result: false),
                    icon: const Icon(Icons.back_hand, color: Colors.green),
                    label: const Text("İPTAL"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(result: true),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text("SİL"),
                  ),
                ),
              ],
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return sonuc ?? false;
    } else {
      showErrorSnackbar(message: "Yetkiniz Bulunmamaktadır");
      return false;
    }
  }

  Future<void> showScannedProduct(Urunler item) async {
    Get.dialog(
      AlertDialog(
        title: const Text("Eşleşen Ürün"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow("Kategori", item.category),
            InfoRow("Ürün Markası", item.marka),
            InfoRow("Urun Açıklaması", item.urun_description),
            InfoRow("Ürün Adedi", item.urun_adet.toString()),
            InfoRow("Ürün Fiyatı", item.urun_fiyat.toString()),
            InfoRow("Ürün Barkod", item.urun_barkod),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  label: const Text("Kapat"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  MobileScannerController barkodController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 500,
    autoZoom: true,
    formats: [
      BarcodeFormat.aztec,
      BarcodeFormat.codabar,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.code128,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.ean8,
      BarcodeFormat.ean13,
      BarcodeFormat.itf,
      BarcodeFormat.pdf417,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );

  void setBarkod(String value) {
    urunBarkod.value = value;
    barkodTextController.text = value;
  }

  void sayfaDegistir(int yeniSayfa) {
    aktifSayfa.value = yeniSayfa;
  }

  @override
  void onInit() {
    super.onInit();
    urunleriGetir();
  }

  Future<void> urunleriGetir() async {
    try {
      final ownerUid = await bringOwnerUid();
      if (ownerUid != "") {
        db
            .collection("users")
            .doc(ownerUid)
            .collection("urunler")
            .snapshots()
            .listen((snapshot) {
              final urunlerListesi = snapshot.docs.map((doc) {
                return Urunler.fromMap(doc.data(), docId: doc.id);
              }).toList();
              urunListesi.value = urunlerListesi;
            });
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Ürünler getirilirken hata: $e");
    }
  }

  Future<void> urunEkleFirebase() async {
    try {
      final varMiYetki = await checkPermission(permissionName: "addProduct");
      final ownerUid = await bringOwnerUid();

      if (varMiYetki) {
        final querySnapshot = await db
            .collection("users")
            .doc(ownerUid)
            .collection("urunler") // kullanıcıya ait ürünler alt koleksiyon
            .where("urun_barkod", isEqualTo: urunBarkod.value)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          print("Bu ürün zaten mevcut");
        } else {
          final newDocRef = db
              .collection("users")
              .doc(ownerUid)
              .collection("urunler")
              .doc(); // Firestore random doc.id üretir

          final urun = Urunler(
            urun_id: newDocRef.id, // 🔹 doc.id’yi buraya ata
            urun_barkod: urunBarkod.value,
            urun_description: urunDescription.value,
            urun_adet: urunAdet.value,
            urun_fiyat: urunFiyat.value,
            category: kategori.value,
            marka: marka.value,
          );

          await newDocRef.set(urun.toMap());
          aktifSayfa.value = 1;
          showSuccessSnackbar(message: "Ürün Başarıyla Eklendi");
          clearForm();
        }
      } else if (!varMiYetki) {
        showErrorSnackbar(message: "Yetkiniz Bulunmamaktadır");
        return;
      }
    } catch (e) {
      showErrorSnackbar(message: "Hata: $e");
    }
  }

  Future<void> alisverisStokGuncelle(String urunIdd, int adet) async {
    // await db.update(
    //   "urunlerListe",
    //   {"urun_adet": adet},
    //   where: "urun_id=?",
    //   whereArgs: [urunIdd],
    // );

    final ownerUid = await bringOwnerUid();
    await db
        .collection("users")
        .doc(ownerUid)
        .collection("urunler")
        .doc(urunIdd)
        .update({"urun_adet": adet});
    await urunleriGetir();
  }

  Future<void> gecmisStokGuncelle({
    required String urunID,
    required int gecmisAdet,
  }) async {
    final ownerUid = await bringOwnerUid();

    final urun = urunListesi.firstWhereOrNull((e) => e.urun_id == urunID);
    print(urun);

    if (urun != null) {
      await db
          .collection("users")
          .doc(ownerUid)
          .collection("urunler")
          .doc(urunID)
          .update({"urun_adet": FieldValue.increment(gecmisAdet)});

      await urunleriGetir();
    } else {
      showErrorSnackbar(message: "Ürün Envanterde Bulunamadı");
    }
  }

  Future<void> urunGuncelle(String urunId) async {
    //tamamlandı
    final ownerUid = await bringOwnerUid();
    final urun = Urunler(
      urun_id: urunId,
      urun_barkod: urunBarkod.value,
      urun_description: urunDescription.value,
      urun_adet: urunAdet.value,
      urun_fiyat: urunFiyat.value,
      category: kategori.value,
      marka: marka.value,
    );

    db
        .collection("users")
        .doc(ownerUid)
        .collection("urunler")
        .doc(urunId)
        .update(urun.toMap());

    Get.back();
  }

  List<Urunler> get filtreliListe {
    //guncellemeye gerek yok
    if (searchProduct.value.isEmpty || searchProduct.value == "") {
      return urunListesi;
    } else {
      return urunListesi.where((urun) {
        return urun.urun_description.toLowerCase().contains(
          searchProduct.value.toLowerCase(),
        );
      }).toList();
    }
  }

  List<String> get kategoriler {
    //guncellemeye gerek yok
    final kategoriSet = urunListesi.map((u) => u.category).toSet();
    final kategoriList = kategoriSet.toList();
    kategoriList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return kategoriList;
  }

  Map<String, List<Urunler>> get groupedProductsByCategory {
    //guncellemeye gerek yok
    final Map<String, List<Urunler>> grouped = {};
    for (var item in urunListesi) {
      final category = item.category;
      if (!grouped.containsKey(category)) grouped[category] = [];
      grouped[category]!.add(item);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  List<String> get markalar {
    //guncellemeye gerek yok
    final markaSet = urunListesi.map((u) => u.marka).toSet();
    final markaList = markaSet.toList();
    markaList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return markaList;
  }

  void barkodUrunArama(String value) async {
    //güncellemeye gerek yok

    final eslesenUrun = urunListesi.firstWhereOrNull(
      (u) => u.urun_barkod == value,
    );

    if (eslesenUrun != null) {
      bool checkperm = await checkPermission(permissionName: "editProduct");
      if (checkperm) {
        await barkodController.stop();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 500));

        // kamera sayfasını kapat
        urunDuzenleDiyalog(eslesenUrun);
      } else {
        await barkodController.stop();
        Get.back();
        await Future.delayed(const Duration(milliseconds: 500));

        showScannedProduct(eslesenUrun);
      }
    } else {
      Get.back();
      showErrorSnackbar(message: "Barkod Bulunamadı");
    }
  }

  Future<void> urunSil({required String urunId}) async {
    //tamamlandı
    String? ownerUid = await bringOwnerUid();
    bool checkperm = await checkPermission(permissionName: "deleteProduct");
    if (checkperm) {
      await db
          .collection("users")
          .doc(ownerUid)
          .collection("urunler")
          .doc(urunId)
          .delete();
    } else {
      showErrorSnackbar(message: "Yetkiniz Bulunmamaktadır");
    }
  }

  void clearForm() {
    urunBarkod.value = "";
    urunDescription.value = "";
    marka.value = "";
    urunAdet.value = 0;
    urunFiyat.value = 0.0;
    kategori.value = "-";
    barkodTextController.clear();
    productCountTextController.clear();
    productDescriptionTextController.clear();
    productPriceTextController.clear();
    productCategoryTextController.clear();
    productMarkaTextController.clear();
  }
}
