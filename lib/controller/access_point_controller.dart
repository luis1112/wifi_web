import 'dart:convert';

import 'package:wifi_web/docs.dart';

class AccessPointController {
  String getIdConnection(String bssid, String uuid) {
    return "$bssid-$uuid";
  }

  Future<ExternalConnection?> getExternalConnection(
      String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var docRef = fConnections.doc(id);
      var subRef = docRef.collection('external');
      var docs = (await subRef.get()).docs;
      var eData = docs.firstOrNull?.data();
      if (eData != null) {
        return ExternalConnection.fromJson(eData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ModelTest?> getTestConnection(String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var docRef = fConnections.doc(id);
      var subRef = docRef.collection('testConnection');
      var docs = (await subRef.get()).docs;
      var eData = docs.firstOrNull?.data();
      if (eData != null) {
        return ModelTest.fromJson(eData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<AllSignalConnection>> getLevel(String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var docRef = fConnections.doc(id);
      var subRef = docRef.collection('signals');
      var data = await subRef
          .where("uuid", isEqualTo: uuid)
          .orderBy("time", descending: true)
          .limit(30)
          .get();
      var docs = data.docs;
      var result = docs.map((e) {
        var eData = e.data() as Map;
        return AllSignalConnection(
          parseInt(eData["signal"]),
          parseInt(eData["time"]),
          parseString(eData["uuid"]),
        );
      }).toList();

      return result;
    } catch (e) {
      printC(e);
      return [];
    }
  }

  Future<List<AllAccessPoint>> getAccessPoints(
      String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var docRef = fConnections.doc(id);
      var subRef = docRef.collection('accessPoints');
      var data = await subRef
          .where("uuid", isEqualTo: uuid)
          .orderBy("time", descending: true)
          .limit(30)
          .get();
      var docs = data.docs;
      var result = docs.map((e) {
        var eData = e.data() as Map;
        List list = jsonDecode(parseString(eData["list"], "[]")).cast();
        var items = list.map((e) => AccessPoint.fromJson(e)).toList();
        return AllAccessPoint(items, parseInt(eData["time"]), eData["uuid"]);
      }).toList();
      return result;
    } catch (e) {
      printC(e);
      return [];
    }
  }
}
