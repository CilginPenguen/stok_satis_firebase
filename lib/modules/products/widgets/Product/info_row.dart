import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../product_controller.dart';

class InfoRow extends GetView<ProductController> {
  final String baslik;
  final String deger;
  const InfoRow(this.baslik, this.deger, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$baslik: $deger", style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
