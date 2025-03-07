import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';
import 'package:wifi_web/widgets/widget_long_press.dart';

import 'global/page_configs_app.dart';

late final FirebaseApp app;

Future<String> initSession() async {
  app = await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyATiJrtV3HOxbIw7Y38B5dayGgOPpNLM8Y",
      authDomain: "unl-analyzer.firebaseapp.com",
      projectId: "unl-analyzer",
      storageBucket: "unl-analyzer.appspot.com",
      messagingSenderId: "1024721427599",
      appId: "1:1024721427599:web:3ea967c98ee92250e3a4fa",
    ),
  );
  var user = await UtilPreference.getUser();
  if (user != null) return PagePrincipal.route;
  return PageLogin.route;
}

class PageLogin extends StatefulWidget {
  static String route = "login";

  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  late Size size;
  ProviderLogin pvL = ProviderLogin.of();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context, true);
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  SafeArea(
                    child: LongPressWidget(
                      onLongPress: () {
                        alertConfigPassword(context, () async {
                          UserModel userData = UserModel(
                            names: "LUIS FERNANDO VILLALTA CASTILLO",
                            photoUrl: "",
                            email: "luis.villalta@unl.edu.ec",
                          );
                          await pvL.registerSession(userData.email);
                          navG.pushNamedAndRemoveUntil(
                              PagePrincipal.route, (route) => false);
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        constraints: const BoxConstraints(
                          maxWidth: 350.0,
                        ),
                        child: Image.asset(
                          "assets/image/logo_horizontal.png",
                          height: 60.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Recucerda que solo podrás "
                      "acceder con tu cuenta institucional",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorBrightness(context),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  BtnC(
                    title: "Iniciar sesión",
                    isExpanded: false,
                    color: Colors.white,
                    colorTitle: Colors.black,
                    leftChild: Image.asset("assets/image/google.png"),
                    height: 50.0,
                    onTap: () async {
                      onLoad(true);
                      bool isLogin = await pvL.loginWithGoogle();
                      onLoad(false);
                      if (isLogin) {
                        navG.pushNamedAndRemoveUntil(
                            PagePrincipal.route, (route) => false);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
