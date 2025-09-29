import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/history/history_controller.dart';
import 'package:stok_satis_firebase/modules/products/product_controller.dart';

class HistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryController());
    Get.put(ProductController());
  }
}
