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
  UserModel? user;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      user = await UtilPreference.getUser();
      if (user != null) {
        pvL.user = user!;
        pvC.getDevices();
      } else {
        navG.pushNamedAndRemoveUntil(PageLogin.route, (route) => false);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context, true);
    pvC = ProviderConnection.of(context, true);
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
            const SizedBox(height: 30.0),
            itemDevices(),
            const SizedBox(height: 30.0),
            if (pvC.uuid.trim().isNotEmpty)
              Expanded(child: itemStreamBuilderConnections())
          ],
        ),
      ),
    );
  }

  Widget itemDevices() {
    if (pvC.listDevices.isEmpty) {
      return const Center(child: Text('No hay dispositivos'));
    }
    return Column(
      children: [
        const Text(
          "Conexiones registradas para el dispositivo: ",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        DropdownButton<DeviceModel?>(
          value: pvC.device,
          items: pvC.listDevices.map((DeviceModel? device) {
            return DropdownMenuItem<DeviceModel?>(
              value: device,
              child:
                  Text('${device?.brand} ${device?.model} (${device?.uuid})'),
            );
          }).toList(),
          onChanged: (device) {
            if (device == null) return;
            if (pvC.device?.uuid == device.uuid) return;
            pvC.device = device;
            pvC.notify();
          },
          hint: const Text('Seleccione un dispositivo'),
        ),
      ],
    );
  }

  Widget itemStreamBuilderConnections() {
    return StreamBuilder<QuerySnapshot>(
      stream: fConnections.where("uuid", isEqualTo: pvC.uuid).snapshots(),
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
          child: ListRowC(
            row: 2,
            children: List.generate(list.length, (index) {
              var e = list[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      navG.pushNamed(
                        PageInfo.route,
                        arguments: {
                          "bssid": e.bssid,
                          "uuid": e.uuid,
                        },
                      );
                    },
                    title: Text(e.ssid),
                    subtitle: Text(e.bssid),
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
