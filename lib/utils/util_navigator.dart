import 'package:flutter/material.dart';

class UtilNavigator {
  NavigatorHistory observerNavigator = NavigatorHistory();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;

  Size get getSize => MediaQuery.of(context).size;

  String? get currentPage {
    String? route;
    nav.popUntil((routeState) {
      route = routeState.settings.name;
      return true;
    });
    return route;
  }

  List<String> get listPages => observerNavigator.routes;

  bool existPageInList(String page) {
    return listPages.where((e) => e == page).isNotEmpty;
  }

  NavigatorState get nav => Navigator.of(context);

  //navigator widget
  pushW(Widget w) => nav.push(_getRW(w));

  pushReplacementW(Widget w) => nav.pushReplacement(_getRW(w));

  //navigator extra
  popUntilName(String r) => nav.popUntil(ModalRoute.withName(r));

  popFirst() {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Object? arguments(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;

  //aux
  MaterialPageRoute _getRW(Widget w) => MaterialPageRoute(builder: (_) => w);
}

class NavigatorHistory extends NavigatorObserver {
  final List<String> routes = [];

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    if (route?.settings.name != null) routes.add(route!.settings.name!);
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    routes.removeWhere((e) => e == route?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    routes.removeWhere((e) => e == oldRoute?.settings.name);
    if (newRoute?.settings.name != null) routes.add(newRoute!.settings.name!);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routes.removeWhere((e) => e == route.settings.name);
  }
}
