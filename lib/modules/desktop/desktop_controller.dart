import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/core/base_controller.dart';
import 'package:stok_satis_firebase/modules/basket/basket_controller.dart';
import 'package:stok_satis_firebase/modules/desktop/widgets/favorites.dart';
import 'package:stok_satis_firebase/modules/products/products_V2.dart';
import 'package:stok_satis_firebase/modules/products/widgets/AddProduct/add_product.dart';

import '../../services/storage_service.dart';
import '../history/history_page.dart';
import '../settings/settings_page.dart';

class DesktopController extends BaseController {
  final currentIndex = 0.obs;
  final x = Get.find<BasketController>();
  final name = "".obs;
  @override
  void onInit() {
    super.onInit();
    loadName();
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return ProductByCategoryPage();
      case 1:
        return AddProduct();
      case 2:
        return HistoryPage();
      case 3:
        return FavoritesPage();
      case 4:
        return SettingsPage();

      default:
        return ProductByCategoryPage();
    }
  }

  Future<void> signOut() async {
    if (isWindows()) {
      if (checkOwner()) {
        await FirebaseAuth.instance.signOut();
      } else {
        final storage = Get.find<StorageService>();
        await storage.remove("staffUid");
        await storage.remove("ownerUid");
        await FirebaseAuth.instance.signOut();
      }
    } else {
      final storage = Get.find<StorageService>();
      await storage.remove("staffUid");
      await storage.remove("ownerUid");
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> loadName() async {
    name.value = await bringNameAndSurname();
  }
}
