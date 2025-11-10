import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:stok_satis_firebase/modules/basket/basket_controller.dart';
import 'package:stok_satis_firebase/modules/desktop/desktop_controller.dart';
import '../core/base_controller.dart';
import '../modules/Auth/auth_controller.dart';
import '../modules/dashboard/dashboard_controller.dart';
import '../modules/history/history_controller.dart';
import '../modules/home/home_controller.dart';
import '../modules/products/product_controller.dart';
import '../services/clock_service.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    // StorageService async initialize ediliyor
    await Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    }, permanent: true);
    if (Platform.isWindows) {
      Get.put(AuthController(), permanent: true);
      Get.put(HomeController(), permanent: true);
      Get.put(HistoryController(), permanent: true);
      Get.put(BasketController(), permanent: T);
      Get.put(BaseController(), permanent: true);
      Get.put(ThemeService(), permanent: true);
      Get.put(DashboardController(), permanent: true);
      Get.put(ClockService(), permanent: true);
      Get.put(DesktopController(), permanent: true);
      Get.put(ProductController(), permanent: true);
    } else {
      // Diğer servis ve controller’lar
      Get.put(BaseController(), permanent: true);
      Get.put(ThemeService(), permanent: true);
      Get.lazyPut(() => HomeController(), fenix: true);
      Get.lazyPut(() => HistoryController(), fenix: true);
      Get.lazyPut(() => DashboardController(), fenix: true);
      Get.lazyPut(() => ProductController(), fenix: true);
      Get.lazyPut(() => AuthController(), fenix: true);
      Get.put(ClockService(), permanent: true);
    }
    await Future.delayed(const Duration(milliseconds: 300));

    if (Get.isRegistered<ProductController>()) {
      Get.find<ProductController>().urunleriGetir();
    }
    if (Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().gecmisGetir();
    }
  }
}
