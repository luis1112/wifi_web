import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PagePrincipal extends StatefulWidget {
  static String route = "principal";

  const PagePrincipal({super.key});

  @override
  State<PagePrincipal> createState() => _PagePrincipalState();
}

class _PagePrincipalState extends State<PagePrincipal> {
  List<ModelTab> listTabs = [];
  ProviderConnection pvC = ProviderConnection.of();
  ProviderLogin pvL = ProviderLogin.of();
  ProviderFirebase pvF = ProviderFirebase.of();
  UserModel? user;

  String get uuid => (pvF.device?.uuid ?? "").trim();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      user = await pvL.getUser;
      if (user != null) {
        await pvF.getUsers();
        pvF.getDevices();
      } else {
        navG.pushNamedAndRemoveUntil(PageLogin.route, (route) => false);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contextPrincipal = context;
    pvL = ProviderLogin.of(context);
    pvC = ProviderConnection.of(context);
    pvF = ProviderFirebase.of(context, true);
    if (user == null) return const PageLoad();
    return Scaffold(
      appBar: AppBar(
        title: const Text("WIFI"),
        backgroundColor: Colors.blueGrey[900],
        actions: actionsAppBar,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: itemDevices(),
            ),
            if (uuid.isNotEmpty) Expanded(child: itemStreamBuilderConnections())
          ],
        ),
      ),
    );
  }

  Widget itemDevices() {
    if (pvF.listDevices.isEmpty) {
      return const Center(child: Text('No hay dispositivos'));
    }
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InputField<UserModel>(
            title: "Usuario: ",
            listSelect: pvF.listUsers,
            valueSelect: pvF.user,
            builderSelect: (v) => '${v.email}',
            onChanged: (v) {
              pvF.user = v;
              pvF.getDevices();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InputField<DeviceModel>(
            title: "Conexiones del dispositivo: ",
            listSelect: pvF.listDevices,
            valueSelect: pvF.device,
            builderSelect: (v) => '${v.brand} ${v.model} (${v.uuid})',
            onChanged: (v) {
              if (pvF.device?.uuid == v.uuid) return;
              pvF.device = v;
              pvF.notify();
            },
          ),
        ),
      ],
    );
  }

  Widget itemStreamBuilderConnections() {
    return StreamBuilder<QuerySnapshot>(
      stream: fConnections.where("uuid", isEqualTo: uuid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: loadCenter());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error de conexión'));
        }

        var documents = snapshot.data?.docs ?? [];

        if (!snapshot.hasData || documents.isEmpty) {
          return const Center(child: Text('No existe información'));
        }

        List<ItemConnection> list = documents
            .map((e) =>
                ItemConnection.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(list.length, (index) {
              var e = list[index];
              return Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(maxWidth: 350.0),
                child: InkWell(
                  onTap: () {
                    pvC.connection = e;
                    navG.pushNamed(
                      PageAnalysis.route,
                      arguments: {
                        "bssid": e.bssid,
                        "uuid": e.uuid,
                      },
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          itemTextG("", e.ssid),
                          itemTextG(e.bssid, ""),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

List<Widget> get actionsAppBar {
  var pvL = ProviderLogin.of();
  return [
    IconButton(
      onPressed: () => pvL.navigatorExit(),
      icon: const Icon(Icons.exit_to_app),
    ),
  ];
}

double getHeightGraph(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  return height / 1.5;
}

double getWidthGraph(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
  return width > 450 ? width / 1.5 : width / 1.2;
}
