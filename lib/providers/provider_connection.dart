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
  TypeChanel? typeChannel;
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

  reset() {
    nowAfterSignal = DateTime.now();
    nowAfterVelocity = DateTime.now();
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

  obtainChartChanel() async {
    var access = accessPoints.where((e) {
      return e.ssid.trim().isNotEmpty;
    }).toList();
    access = access.where((e) {
      if (e.frequency < 5000 && typeChannel == TypeChanel.ghz2) return true;
      if (e.frequency >= 5000 && typeChannel == TypeChanel.ghz5) return true;
      if (typeChannel == null) return true;
      return false;
    }).toList();
    List<ItemChartChanel> listAux = [];
    for (var e in access) {
      var channel = calculateChannel(e.frequency, true);
      var color = generateUniqueRandomColor(
        listAux.map((e) => e.color).toList(),
        access.indexOf(e),
        e.level,
      );
      var item =
          listChartChanel(color, channel, e.level, e.channelWidth, typeChannel);
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
  obtainChartIntensity() {
    listPoints = [];
    listPointsAux = [];
    var nowBefore = DateTime.now();
    for (var e in listAllSignal.reversed) {
      level = e.signal;
      obtainChartIntensityItem(nowBefore);
      nowBefore = nowBefore.copyWith(second: nowBefore.second + 2);
      notify();
    }
  }

  obtainChartIntensityItem(DateTime nowBefore) async {
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

  int calculateChannel(int frequency, bool isOther) {
    if (frequency >= 2412 && frequency <= 2484) {
      var item = isOther ? 3 : 1;
      return ((frequency - 2412) ~/ 5 + item).toInt();
    } else if (frequency >= 5180 && frequency <= 5825) {
      return (((frequency - 5180) ~/ 5) + 36).toInt();
    }
    return 0;
  }
}
