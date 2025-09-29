import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/app_colors.dart';
import '../home_controller.dart';
import 'index_menu.dart';

class BotNavBar extends GetView<HomeController> {
  const BotNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedBottomNavigationBar.builder(
        itemCount: 4,
        tabBuilder: (int index, bool isActive) {
          final icons = [
            Icons.home_rounded,
            Icons.inventory_2_outlined,
            Icons.manage_history,
            Icons.settings,
          ];

          return GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.withAlpha(255)
                        : Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: SafeArea(top: false, child: IndexMenu(index: index)),
                ),
              );
            },
            child: Icon(
              icons[index],
              color: isActive ? Colors.white : Colors.black,
            ),
          );
        },
        activeIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        gapLocation: GapLocation.center,
        backgroundColor: AppColors.tiffanyBlue,
        splashColor: AppColors.yellow,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
      ),
    );
  }
}
