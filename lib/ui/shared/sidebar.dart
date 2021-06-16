import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/sidemenu_provider.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/services/navigation_service.dart';

import 'package:admin_dashboard/ui/shared/widgets/logo.dart';
import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/text_separator.dart';

class Sidebar extends StatelessWidget {
  void navigateTo(String routeName) {
    NavigationService.replaceTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 50),
          TextSeparator(
            text: 'Main',
          ),
          MenuItem(
            text: 'Dashboard',
            icon: Icons.compass_calibration_outlined,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardRoute),
          ),
          MenuItem(
            text: 'Orders',
            icon: Icons.shopping_cart_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Analytics',
            icon: Icons.show_chart_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Categories',
            icon: Icons.layers_outlined,
            isActive: sideMenuProvider.currentPage ==
                Flurorouter.dashboardCategoriesRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardCategoriesRoute),
          ),
          MenuItem(
            text: 'Products',
            icon: Icons.dashboard_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Discount',
            icon: Icons.attach_money_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Users',
            icon: Icons.people_alt_outlined,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardUsersRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardUsersRoute),
          ),
          SizedBox(height: 30),
          TextSeparator(
            text: 'UI Elements',
          ),
          MenuItem(
            text: 'Icons',
            icon: Icons.list_alt_outlined,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardIconsRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardIconsRoute),
          ),
          MenuItem(
            text: 'Marketing',
            icon: Icons.mark_email_read_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Campaign',
            icon: Icons.note_add_outlined,
            onPressed: () {},
          ),
          MenuItem(
            text: 'Blank Page',
            icon: Icons.post_add_outlined,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardBlankRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardBlankRoute),
          ),
          SizedBox(height: 50),
          TextSeparator(
            text: 'Exit',
          ),
          MenuItem(
            text: 'Log Out',
            icon: Icons.exit_to_app_outlined,
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xff092044),
          Color(0xff092042),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
        ),
      ],
    );
  }
}
