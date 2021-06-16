import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/ui/views/no_page_found_view.dart';

class NoPageFoundeHandlers {
  static Handler noPageFound = new Handler(handlerFunc: (context, params) {
    final pro = Provider.of<SideMenuProvider>(context!, listen: false);
    pro.setCurrentPageUrl('/404');
    return NoPageFoundView();
  });
}
