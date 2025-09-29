import 'package:get/get.dart';
import 'basket_controller.dart';

class BasketBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BasketController());
  }
}
