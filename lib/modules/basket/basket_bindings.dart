import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/products/product_controller.dart';
import 'basket_controller.dart';

class BasketBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BasketController());
    Get.put(ProductController());
  }
}
