import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_web/docs.dart';

class ProviderFirebase with ChangeNotifier {
  static ProviderFirebase of([BuildContext? context, bool listen = false]) {
    return Provider.of<ProviderFirebase>(context ?? contextG, listen: listen);
  }

  notify() => notifyListeners();

  //controllers
  AccessPointController accessC = AccessPointController();
  StreamSubscription? connectionSubscription;
  StreamSubscription? streamSubscription;

  //devices
  List<DeviceModel> listDevices = [];
  DeviceModel? device;
  DateTime dateTime = DateTime.now();

  getDevices() async {
    device = null;
    ProviderLogin pvL = ProviderLogin.of();
    listDevices = await UserController().getDevicesByEmail(pvL.user.email);
    if (listDevices.isNotEmpty) {
      device = listDevices.first;
      notify();
    }
  }

  initListen(BuildContext context, String bssid, String uuid,
      DateTime dateTime) async {
    if (!context.mounted) return;
    var pvC = ProviderConnection.of(context);
    this.dateTime = dateTime;
    connectionSubscription?.cancel();
    var id = accessC.getIdConnection(bssid, uuid);
    var idAnalysis = accessC.getIdAnalysis(dateTime);
    var docRef = fAnalysis(id).doc(idAnalysis);
    streamSubscription = fConnections.doc(id).snapshots().listen((data) async {
      // streamSubscription = docRef.snapshots().listen((data) async {
      if (data.exists && context.mounted) {
        pvC.reset();
        var dataC = await accessC.getConnection(bssid, uuid);
        if (dataC != null) pvC.connection = dataC;
        initData(context, bssid, uuid, dateTime);
      } else {
        pvC.connection = ItemConnection();
      }
      notify();
    });
    streamSubscription = docRef.snapshots().listen((data) {});
  }

  initData(BuildContext context, String bssid, String uuid,
      DateTime dateTime) async {
    if (!context.mounted) return;
    var pvC = ProviderConnection.of(context);
    if (bssid.trim().isEmpty) return;
    accessC
        .getExternalConnection(bssid, uuid, dateTime)
        .then((v) => pvC.external = v);
    accessC.getTestConnection(bssid, uuid, dateTime).then((v) => pvC.test = v);
    pvC.accessPointsAll = await accessC.getAccessPoints(bssid, uuid, dateTime);
    pvC.accessPoints = pvC.accessPointsAll.firstOrNull?.list ?? [];
    if (pvC.accessPointsAll.isNotEmpty) {
      pvC.obtainChartChanel();
      pvC.obtainChartSignal();
    }
    pvC.listAllSignal = await accessC.getLevel(bssid, uuid, dateTime);
    if (pvC.listAllSignal.isNotEmpty) {
      pvC.obtainChartIntensity();
    }
    notify();
    pvC.notify();
  }
}
