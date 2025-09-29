import 'package:flutter/material.dart';

import 'widgets/history_expansionTile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geçmiş Satışlar")),
      body: HistoryExpansionTile(),
    );
  }
}
