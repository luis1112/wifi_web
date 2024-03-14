import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_web/docs.dart';

class ProviderConnection with ChangeNotifier {
  static ProviderConnection of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderConnection>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  //controllers
  AccessPointController accessC = AccessPointController();
  StreamSubscription? streamSubscription;

  //devices
  List<DeviceModel> listDevices = [];
  DeviceModel? device;

  //test
  ModelTest? test;

  //external
  ExternalConnection? external;

  //WiFiAccessPoint
  List<AllAccessPoint> accessPointsAll = [];
  List<AccessPoint> accessPoints = [];
  ItemConnection connection = ItemConnection();

  //chanel
  bool isActiveNetwork = false;
  TypeChanel? typeChanel;
  List<ItemChartChanel> lineBarsData = [];

  //signal
  int limitCount = 30;
  TypeChanel? typeSignal;
  List<AllSignalConnection> listAllSignal = [];
  List<ItemChartSignal> listSignal = [];
  DateTime nowAfterSignal = DateTime.now();

  //velocity
  DateTime nowAfterVelocity = DateTime.now();
  List<FlSpot> listPointsAux = [];
  List<FlSpot> listPoints = [];
  int level = 0;

  //uuid
  String get uuid => device?.uuid ?? "";

  String get bssid => connection.bssid;

  reset() {
    nowAfterSignal = DateTime.now();
    nowAfterVelocity = DateTime.now();
  }

  getDevices() async {
    device = null;
    ProviderLogin pvL = ProviderLogin.of();
    listDevices = await UserController().getDevicesByEmail(pvL.user.email);
    if (listDevices.isNotEmpty) {
      device = listDevices.first;
      notify();
    }
  }

  initListen(String bssid, String uuid) async {
    streamSubscription?.cancel();
    var id = accessC.getIdConnection(bssid, uuid);
    streamSubscription = fConnections.doc(id).snapshots().listen((data) {
      if (data.exists) {
        printC("OBTENIENDO MAS INFORMACIÓN");
        reset();
        connection = ItemConnection.fromJson(
          data.data() as Map<String, dynamic>,
        );
        initData();
      } else {
        connection = ItemConnection();
      }
      notify();
    });
  }

  initData() async {
    if (bssid.trim().isEmpty) return;
    accessC.getExternalConnection(bssid, uuid).then((v) => external = v);
    accessC.getTestConnection(bssid, uuid).then((v) => test = v);
    accessPointsAll = await accessC.getAccessPoints(bssid, uuid);
    accessPoints = accessPointsAll.firstOrNull?.list ?? [];
    if (accessPointsAll.isNotEmpty) {
      obtainChartChanel();
      obtainChartSignal();
    }
    listAllSignal = await accessC.getLevel(bssid, uuid);
    if (listAllSignal.isNotEmpty) {
      obtainChartVelocity();
    }
    notify();
  }

  double calculateDistanceRouter(int rssi) {
    // Constantes para el modelo de pérdida de ruta (Path Loss Model)
    double n = 2; // Exponente de atenuación (generalmente entre 2 y 4)
    double A = -50; // Valor de referencia del RSSI a 1 metro de distancia

    // Fórmula para calcular la distancia
    double distancia = pow(10, ((A - rssi) / (10 * n))).toDouble();
    return double.parse(distancia.toStringAsFixed(2));
  }

  String? getChanelWifi(String bssid) {
    var v = accessPoints.where((e) => e.bssid == bssid).firstOrNull;
    var channelWidth = v?.channelWidth;
    if (channelWidth != null) return "$channelWidth mhz";
    return null;
  }

  obtainChartChanel() {
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    access = access.where((e) {
      if (e.frequency < 5000 && typeChanel == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeChanel == TypeChanel.ghz5) return true;
      if (typeChanel == null) return true;
      return false;
    }).toList();
    List<ItemChartChanel> listAux = [];
    for (var e in access) {
      var chanel = e.channelWidth;
      // var chanel =
      // int.parse("${e.channelWidth.name ??20}".replaceAll("mhz", ""));
      var color = generateUniqueRandomColor(
        listAux.map((e) => e.color).toList(),
        access.indexOf(e),
        e.level,
      );
      // var eAux = lineBarsData.where((i) => i.item.ssid == e.ssid).firstOrNull;
      // color = eAux?.color ?? color;
      var item = listChartChanel(color, chanel, e.level);
      if (item != null) {
        listAux.add(ItemChartChanel(e, item, color));
      }
    }
    lineBarsData = listAux;
  }

  // signal
  obtainChartSignal() async {
    listSignal = [];
    var nowBefore = DateTime.now();
    for (var e in accessPointsAll.reversed) {
      accessPoints = e.list;
      obtainChartSignalItem(nowBefore);
      nowBefore = nowBefore.copyWith(second: nowBefore.second + 2);
      notify();
    }
  }

  obtainChartSignalItem(DateTime nowBefore) {
    var diff = nowBefore.difference(nowAfterSignal).inSeconds;
    if (diff >= limitCount) {
      nowAfterSignal = DateTime.now();
    }
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    // accessPoints = pvC.accessPoints;
    access = access.where((e) {
      if (e.frequency < 5000 && typeSignal == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeSignal == TypeChanel.ghz5) return true;
      if (typeSignal == null) return true;
      return false;
    }).toList();
    List<ItemChartSignal> listAdd = [];
    // var e = pvC.accessPoints[0];
    for (var e in access) {
      var listAux = listSignal.where((el) => el.item.bssid == e.bssid).toList();
      List<FlSpot> listPointsAux = listAux.isNotEmpty ? listAux[0].listAux : [];
      listPointsAux.add(
          FlSpot(nowBefore.millisecondsSinceEpoch + 0.0, e.level.toDouble()));
      listPointsAux = listPointsAux.where((e) {
        var datePoint = DateTime.fromMillisecondsSinceEpoch(e.x.toInt());
        var diffAux = nowBefore.difference(datePoint).inSeconds;
        return diffAux <= limitCount;
      }).toList();
      List<FlSpot> listPoints = [];
      for (var point in listPointsAux) {
        var datePoint = DateTime.fromMillisecondsSinceEpoch(point.x.toInt());
        var diffAux = nowBefore.difference(datePoint).inSeconds;
        listPoints.add(FlSpot(diffAux + 0.0, point.y));
      }
      var color = generateUniqueRandomColor(
        listAdd.map((e) => e.color).toList(),
        access.indexOf(e),
        e.level,
      );
      // var eAux = listSignal.where((i) => i.item.ssid == e.ssid).firstOrNull;
      // color = eAux?.color ?? color;
      listAdd.add(ItemChartSignal(e, listPoints, listPointsAux, color));
    }
    listSignal = listAdd;
  }

  // velocity
  obtainChartVelocity() {
    listPoints = [];
    var nowBefore = DateTime.now();
    for (var e in listAllSignal.reversed) {
      level = e.signal;
      obtainChartVelocityItem(nowBefore);
      nowBefore = nowBefore.copyWith(second: nowBefore.second + 2);
      notify();
    }
  }

  obtainChartVelocityItem(DateTime nowBefore) async {
    //if conectado

    // var nowBefore = DateTime.now();
    var diff = nowBefore.difference(nowAfterVelocity).inSeconds;
    if (diff >= limitCount) {
      nowAfterVelocity = DateTime.now();
    }
    listPointsAux
        .add(FlSpot(nowBefore.millisecondsSinceEpoch + 0.0, level.toDouble()));
    listPointsAux = listPointsAux.where((e) {
      var datePoint = DateTime.fromMillisecondsSinceEpoch(e.x.toInt());
      var diffAux = nowBefore.difference(datePoint).inSeconds;
      return diffAux <= limitCount;
    }).toList();
    listPoints = [];
    for (var point in listPointsAux) {
      var datePoint = DateTime.fromMillisecondsSinceEpoch(point.x.toInt());
      var diffAux = nowBefore.difference(datePoint).inSeconds;
      listPoints.add(FlSpot(diffAux + 0.0, point.y));
    }
  }
}
