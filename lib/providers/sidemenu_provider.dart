import 'package:admin_dashboard/router/router.dart';
import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  static late AnimationController menuController;
  static bool isOpen = false;

  String _currentPage = Flurorouter.dashboardRoute;
  String get currentPage => _currentPage;

  void setCurrentPageUrl(String routeName) {
    this._currentPage = routeName;
    Future.delayed(Duration(milliseconds: 100), () => notifyListeners());
  }

  static Animation<double> movement = Tween<double>(begin: -200, end: 0)
      .animate(
          CurvedAnimation(parent: menuController, curve: Curves.easeInOut));

  static Animation<double> opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: menuController, curve: Curves.easeInOut));
  static void openMenu() {
    isOpen = true;
    menuController.forward();
  }

  static void closeMenu() {
    isOpen = false;
    menuController.reverse();
  }

  static void toggleMenu() {
    isOpen ? menuController.reverse() : menuController.forward();
    isOpen = !isOpen;
  }
}
