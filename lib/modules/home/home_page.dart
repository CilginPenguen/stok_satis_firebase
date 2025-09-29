import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/products/widgets/Product/product_floatAction.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';
import 'home_controller.dart';
import 'widgets/BotNavBar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.buildPage(controller.currentIndex.value)),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0,
        child: Obx(
          () => controller.currentIndex.value == 1
              ? ProductFloatingAction()
              : FloatingActionButton(
                  onPressed: () => Get.toNamed(AppRoutes.basket),
                  backgroundColor: AppColors.darkHotPink,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BotNavBar(),
    );
  }
}
