import 'package:flutter/material.dart';

import '../../../models/owner.dart';
import 'info_listtile.dart';

class OwnerCard extends StatelessWidget {
  const OwnerCard({super.key, required this.o});

  final Owner o;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InfoListtile(baslik: "İsim", bilgi: o.name),
          InfoListtile(baslik: "Soy İsim", bilgi: o.surname),
          InfoListtile(baslik: "E-Mail", bilgi: o.email),
          InfoListtile(baslik: "Katılış Tarihi", bilgi: o.joinedAt.toString()),
        ],
      ),
    );
  }
}
