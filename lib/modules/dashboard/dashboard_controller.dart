import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/home/home_controller.dart';
import 'package:stok_satis_firebase/modules/products/product_controller.dart';

import '../../core/base_controller.dart';
import '../../services/storage_service.dart';
import '../history/history_controller.dart';

class DashboardController extends BaseController {
  RxBool isExpanded = false.obs;
  final aylikGelir = 0.0.obs;
  final aylikGider = 0.0.obs;
  var hc = Get.find<HistoryController>();

  Future<void> removeProductController() async {
    if (Get.isRegistered<ProductController>()) {
      await Get.delete<HomeController>(force: true);
    }
  }

  List<String> sayiTipi = [
    " ",
    " ",
    "III",
    " ",
    " ",
    "VI",
    " ",
    " ",
    "IX",
    " ",
    " ",
    "XII",
  ];

  @override
  void onInit() async {
    await hc.gecmisGetir();
    hc.gecmisList;
    super.onInit();
  }

  Future<void> signOut() async {
    final storage = Get.find<StorageService>();
    await storage.remove("staffUid");
    await storage.remove("ownerUid");
    await FirebaseAuth.instance.signOut();
  }
}
