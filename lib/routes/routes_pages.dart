import 'package:wifi_web/docs.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
      PageLogin.route: (_) => const PageLogin(),
      PagePrincipal.route: (_) => const PagePrincipal(),
      PageInfo.route: (_) => const PageInfo(),
      PageInform.route: (_) => const PageInform(),
    };
