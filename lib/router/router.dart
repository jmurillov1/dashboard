import 'package:fluro/fluro.dart';

import 'package:admin_dashboard/router/admin_handlers.dart';
import 'package:admin_dashboard/router/dashboard_handlers.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';
  //Auth Routes
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';

  //Dashboard Routes
  static String dashboardRoute = '/dashboard';
  static String dashboardBlankRoute = '/dashboard/blank';
  static String dashboardCategoriesRoute = '/dashboard/categories';
  static String dashboardIconsRoute = '/dashboard/icons';
  static String dashboardUsersRoute = '/dashboard/users';
  static String dashboardUserRoute = '/dashboard/users/:uid';

  static void configureRoutes() {
    //AuthDefine
    router.define(rootRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(loginRoute,
        handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(registerRoute,
        handler: AdminHandlers.register, transitionType: TransitionType.none);
    //DashboardDefine
    router.define(dashboardRoute,
        handler: DashboardHandlers.dashboard,
        transitionType: TransitionType.fadeIn);
    router.define(dashboardCategoriesRoute,
        handler: DashboardHandlers.dashboardCategories,
        transitionType: TransitionType.fadeIn);
    router.define(dashboardUsersRoute,
        handler: DashboardHandlers.dashboardUsers,
        transitionType: TransitionType.fadeIn);
    router.define(dashboardUserRoute,
        handler: DashboardHandlers.dashboardUser,
        transitionType: TransitionType.fadeIn);
    router.define(dashboardIconsRoute,
        handler: DashboardHandlers.dashboardIcons,
        transitionType: TransitionType.fadeIn);
    router.define(dashboardBlankRoute,
        handler: DashboardHandlers.dashboardBlank,
        transitionType: TransitionType.fadeIn);
    //404 route
    router.notFoundHandler = NoPageFoundeHandlers.noPageFound;
  }
}
