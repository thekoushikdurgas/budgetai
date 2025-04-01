import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgetai/core/constants/color_constants.dart';
import 'package:budgetai/generated/codegen_loader.g.dart';
import 'package:budgetai/features/home/view/home_view.dart';
import 'package:budgetai/features/settings/view/settings_view.dart';
import 'package:budgetai/features/sms/view/sms_view.dart';
import 'package:budgetai/features/budget/view/budget_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  late CupertinoTabController tabController;

  @override
  void initState() {
    tabController = CupertinoTabController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: tabController,
      tabBar: CupertinoTabBar(
        border: const Border(),
        currentIndex: 0,
        backgroundColor: Colors.transparent,
        activeColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightPrimaryIcon,
          darkColor: ColorConstants.darkPrimaryIcon,
        ),
        inactiveColor: CupertinoDynamicColor.withBrightness(
          color: ColorConstants.lightInactive,
          darkColor: ColorConstants.darkInactive,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.house_alt_fill),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.money_dollar_circle_fill),
            label: LocaleKeys.budget.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.envelope_fill),
            label: LocaleKeys.sms_analysis.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings_solid),
            label: LocaleKeys.settings.tr(),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return const HomeView();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return const BudgetView();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return const SmsView();
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return const SettingsView();
              },
            );
          default:
            tabController.index = 0;
            return const HomeView();
        }
      },
    );
  }
}
