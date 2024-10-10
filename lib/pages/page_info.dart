import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PageInfo extends StatefulWidget {
  static String route = "info";
  final String bssid;

  const PageInfo({super.key, this.bssid = ""});

  @override
  State<PageInfo> createState() => _PageInfoState();
}

class _PageInfoState extends State<PageInfo> {
  List<ModelTab> listTabs = [];
  ProviderConnection pvC = ProviderConnection.of();
  ProviderLogin pvL = ProviderLogin.of();
  ProviderFirebase pvF = ProviderFirebase.of();
  UserModel? user;

  //args
  String bssid = "";
  String uuid = "";
  int time = 0;

  bool get isCompleteInfo =>
      bssid.trim().isNotEmpty && uuid.trim().isNotEmpty && time != 0;
  int? indexSelect = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      user = pvF.user;
      if (user != null && isCompleteInfo) {
        var dateTme = DateTime.fromMillisecondsSinceEpoch(time);
        pvF.initListen(context, bssid, uuid, dateTme);
      } else {
        navG.pushNamedAndRemoveUntil(PagePrincipal.route, (route) => false);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    pvF.streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context);
    pvC = ProviderConnection.of(context, true);
    pvF = ProviderFirebase.of(context);
    var arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map) {
      bssid = parseString(arg["bssid"]);
      uuid = parseString(arg["uuid"]);
      time = parseInt(arg["time"]);
    }
    // bssid = widget.bssid;
    if (user == null) return const PageLoad();
    listTabs = [
      ModelTab("Conexión", const PageConnection()),
      ModelTab("Externo", const PageExternal()),
      ModelTab("Intensidad", const PageVelocity()),
      ModelTab("Test Velocidad", const PageTest()),
      ModelTab("Canales", const PageChanel()),
      ModelTab("Señal", const PageSignal()),
      ModelTab("Puntos de acceso", const PageAccessPoint()),
      ModelTab("Informe", const PageInform()),
    ];
    return DefaultTabController(
      length: listTabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (utilNavG.listPages.isNotEmpty) {
                navG.pop();
              } else {
                navG.pushNamedAndRemoveUntil(
                    PagePrincipal.route, (route) => false);
              }
            },
          ),
          title: Text("${pvC.connection.ssid} - ${pvC.connection.bssid}"),
          backgroundColor: Colors.blueGrey[900],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.green,
            indicatorWeight: 3.0,
            onTap: (i) {
              indexSelect = i;
              setState(() {});
            },
            tabs: List.generate(listTabs.length, (index) {
              var item = listTabs[index];
              return Tab(
                icon: item.icon == null ? null : Icon(item.icon!),
                child: Text(
                  item.title.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
          ),
          actions: actionsAppBar,
        ),
        body: Stack(
          children: [
            Builder(
              builder: (context) {
                if (pvC.connection.bssid.trim().isEmpty) {
                  return const Center(child: Text('No existe información'));
                }
                // Muestra los datos en la interfaz de usuario
                return TabBarView(
                  children: List.generate(listTabs.length, (index) {
                    var item = listTabs[index];
                    return item.child;
                  }),
                );
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: itemFloatingActionButton(),
      ),
    );
  }

  Widget? itemFloatingActionButton() {
    if (indexSelect == listTabs.length - 1) return Container();
    return BtnC(
      title: "Eliminar informe",
      color: Colors.red,
      colorBorderSide: Colors.red,
      onTap: () {
        alertMessage(context,
            message: "¿Estás seguro de elimiar informe?\n"
                "Esta opción eliminará el documento para siempre",
            titleBtnAgree: "Eliminar",
            titleBtnCancel: "Cancelar", onTap: () async {
          navG.pop();
          var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
          await AccessPointController().deleteAnalysis(bssid, uuid, dateTime);
          navG.pop();
        }, onTapCancel: () {
          navG.pop();
        });
      },
    );
  }
}

class ModelTab {
  String title;
  Widget child;
  IconData? icon;

  ModelTab(
    this.title,
    this.child, {
    this.icon,
  });
}
