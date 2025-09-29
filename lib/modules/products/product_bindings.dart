import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/products/product_controller.dart';

class ProductBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController());
  }
}
