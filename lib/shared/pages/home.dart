import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/past_health_records/pages/past_health_records_page.dart';
import 'package:smartwatch_companion/realtime_health_data/pages/dashboard_page.dart';
import 'package:smartwatch_companion/settings/pages/settings_page.dart';

class Home extends StatelessWidget {
  static get path => '/home';
  static get name => 'home';
  static get route => StatefulShellRoute(
        builder: (_, __, shell) => shell,
        branches: [
          StatefulShellBranch(routes: [DashboardPage.route]),
          StatefulShellBranch(routes: [PastHealthRecordsPage.route]),
          StatefulShellBranch(routes: [SettingsPage.route]),
        ],
        navigatorContainerBuilder: (context, navigationShell, children) {
          return Home(navigationShell: navigationShell, children: children);
        },
      );

  Home(
      {super.key,
      required StatefulNavigationShell navigationShell,
      required List<Widget> children})
      : _navigationShell = navigationShell,
        _children = children;

  final StatefulNavigationShell _navigationShell;
  final List<Widget> _children;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => _navigationShell.goBranch(index),
        children: _children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationShell.currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          _navigationShell.goBranch(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Health Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
