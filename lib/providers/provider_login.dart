import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:wifi_web/docs.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class ProviderLogin with ChangeNotifier {
  static ProviderLogin of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderLogin>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  UserModel user = UserModel.fromJson({});

  Future<bool> loginWithGoogle() async {
    try {
      var u = await googleSignIn.signIn();
      var email = u?.email ?? "";
      // var email = "jimmy.vicente@unl.edu.ec";
      if (email.contains("@unl.edu.ec")) {
        var userData = await UserController().getUserByUuid(email);
        if (userData != null && userData.rol.contains("web")) {
          UtilPreference.setUser(userData);
          return true;
        } else {
          pvG.showMessage(
              "Este usuario no esta autorizado para utilizar la pagina web",
              onTap: () {
            utilNavG.popUntilName(PageLogin.route);
          });
        }
      } else {
        await googleSignIn.signOut();
        pvG.showMessage(
            "El corre con el que deseas ingresar no tiene el dominio de"
            " la Universidad @unl.edu.ec", onTap: () {
          utilNavG.popUntilName(PageLogin.route);
        });
      }
    } catch (error) {
      printC("________________");
      printC(error);
      pvG.showMessage("");
    }
    notify();
    return false;
  }

  navigatorExit() {
    BuildContext context = contextG;
    alertMessage(
      context,
      message:
          "¿Estás seguro de que deseas cerrar sesión de ${DeviceInfo.appName}?",
      title: "Cerrando sesión",
      titleBtnAgree: "Si, cerrar sesión",
      titleBtnCancel: "Cancelar",
      barrierDismissible: true,
      onTap: () async {
        await UtilPreference.deleteUser();
        await googleSignIn.signOut();
        navG.pushNamedAndRemoveUntil(PageLogin.route, (route) => false);
      },
    );
  }
}
