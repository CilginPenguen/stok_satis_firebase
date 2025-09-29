import 'package:flutter/material.dart';

class InfoListtile extends StatelessWidget {
  final String baslik;
  final String bilgi;
  const InfoListtile({super.key, required this.baslik, required this.bilgi});

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Text(baslik), trailing: Text(bilgi));
  }
}
