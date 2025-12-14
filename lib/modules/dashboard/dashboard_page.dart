// dashboard_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

import '../../services/clock_service.dart';
import '../../utils/themes/app_colors.dart';
import '../history/history_controller.dart';
import 'dashboard_controller.dart';
import 'widgets/analog_saat.dart';
import 'widgets/daily_sales.dart';
import 'widgets/main_screen.dart';
import 'widgets/summary_card.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();
    final ClockService clockService = Get.find<ClockService>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () => exit(0),
            icon: Icon(Icons.power_settings_new_outlined),
          ),
          IconButton(
            onPressed: () async {
              await controller.signOut();
              Get.offAllNamed(AppRoutes.auth);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Obx(
                    () => SummaryCard(
                      title: "Aylık Gelir",
                      amount: historyController.monthlyIncome.value,
                      icon: Icons.calendar_month,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkIncome
                          : AppColors.income,
                      gradientColors:
                          Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkIncomeGradient
                          : AppColors.incomeGradient,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: Obx(
                    () => SummaryCard(
                      title: "Günlük Gelir",
                      amount: historyController.dailyIncome.value,
                      icon: Icons.calendar_today,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkIncome
                          : AppColors.income,
                      gradientColors:
                          Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkIncomeGradient
                          : AppColors.incomeGradient,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [Flexible(fit: FlexFit.loose, child: DailySales())],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Obx(
                () => Center(
                  child: IntrinsicWidth(
                    child: clockService.clockMode ? AnalogSaat() : MainScreen(),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: clockService.clockMode,
                child: OutlinedButton(
                  onPressed: () => clockService.toggleClock(),
                  child: Text("Saati Kapat"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
