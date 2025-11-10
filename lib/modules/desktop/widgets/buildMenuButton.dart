import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/desktop/desktop_controller.dart';

class Buildmenubutton extends GetView<DesktopController> {
  final IconData icon;
  final String label;
  final int index;
  const Buildmenubutton({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;

      return InkWell(
        onTap: () => controller.currentIndex.value = index,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal[300] : Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
