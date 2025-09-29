import 'package:flutter/material.dart';

import '../../../models/staff.dart';
import 'info_listtile.dart';

class StaffCard extends StatelessWidget {
  const StaffCard({super.key, required this.s});

  final Staff s;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InfoListtile(baslik: "İsim", bilgi: s.firstName),
          InfoListtile(baslik: "Soyisim", bilgi: s.lastName),
          InfoListtile(baslik: "Kayıt Tarihi", bilgi: s.joinedAt.toString()),
          ListTile(
            leading: const Text("Yetkiler -->"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // taşma hatası olmasın
              children: [
                Column(
                  children: [
                    const Text("Ekle"),
                    Icon(
                      s.permissions.addProduct
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: s.permissions.addProduct
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    const Text("Düzenle"),
                    Icon(
                      s.permissions.editProduct
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: s.permissions.editProduct
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    const Text("Sil"),
                    Icon(
                      s.permissions.deleteProduct
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: s.permissions.deleteProduct
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
