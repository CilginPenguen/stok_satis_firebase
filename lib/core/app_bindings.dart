import 'package:get/get.dart';
import '../core/base_controller.dart';
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

    // Diğer servis ve controller’lar
    Get.put(BaseController(), permanent: true);
    Get.put(ThemeService(), permanent: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => HistoryController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.put(ClockService(), permanent: true);
  }
}
