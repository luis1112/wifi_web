import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wifi_web/docs.dart';
import 'package:fluro/fluro.dart';

//navigators
UtilNavigator utilNavG = UtilNavigator();

NavigatorState get navG => utilNavG.nav;

BuildContext get contextG => utilNavG.context;

void main() async {
  //vertical screen
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var route = await initSession();
  runApp(MyApp(route));
}

class MyApp extends StatefulWidget {
  final String route;

  const MyApp(this.route, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

FluroRouter fluroRouter = FluroRouter();

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    fluroRouter.define(
      '/info/:bssid',
      handler: Handler(
        handlerFunc: (context, params) => PageInfo(
          bssid: (params['bssid'] ?? [])[0],
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Wifi',
        debugShowCheckedModeBanner: false,
        navigatorKey: utilNavG.navigatorKey,
        navigatorObservers: [utilNavG.observerNavigator],
        initialRoute: widget.route,
        routes: routes,
        onGenerateRoute: fluroRouter.generator,
        // onGenerateRoute: (settings) {
        //   // Extrae los argumentos de settings.arguments
        //   if (settings.name == '/details') {
        //     final args = settings.arguments as Map<String, dynamic>;
        //     return MaterialPageRoute(
        //       builder: (context) => DetailsScreen(data: args['data']),
        //     );
        //   }
        //   return null;
        // },
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UtilTheme.primary,
            brightness: Brightness.light,
          ),
          primarySwatch: getMaterialColor(UtilTheme.primary),
          primaryColor: UtilTheme.primary,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UtilTheme.primary,
            brightness: Brightness.dark,
          ),
          primarySwatch: getMaterialColor(UtilTheme.primary),
          primaryColor: UtilTheme.primary,
        ),
        builder: (_, child) => PageGlobal(
          child: child,
          onChangeTheme: () => setState(() {}),
        ),
      ),
    );
  }
}

printC(dynamic obj) {
  debugPrint("________________________");
  debugPrint("$obj");
  debugPrint("________________________");
}
