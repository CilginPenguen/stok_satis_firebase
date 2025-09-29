import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/products/product_controller.dart';
import 'package:stok_satis_firebase/modules/products/widgets/Product/mevcut_sayfa.dart';

import '../../core/base_controller.dart';
import '../../models/sepet_liste.dart';
import '../dashboard/dashboard_page.dart';
import '../history/history_page.dart';
import '../settings/settings_page.dart';

class HomeController extends BaseController {
  final currentIndex = 0.obs;
  final backupBasketList = <Sepet>[].obs;

  changePage(int index) {
    currentIndex.value = index;
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return DashboardPage();
      case 1:
        return MevcutSayfa();
      case 2:
        return HistoryPage();
      case 3:
        return SettingsPage();
      default:
        return DashboardPage();
    }
  }
}
