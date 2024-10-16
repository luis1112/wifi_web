import 'dart:convert';

import 'package:wifi_web/docs.dart';

class AccessPointController {
  String getIdConnection(String bssid, String uuid) {
    return "$bssid-$uuid";
  }

  String getIdAnalysis(DateTime dateTime) {
    return "${dateTime.millisecondsSinceEpoch}";
  }

  Future<ItemConnection?> getConnection(String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var data = fConnections.doc(id);
      var cData = await data.get();
      if (cData.exists) {
        return ItemConnection.fromJson(cData.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ExternalConnection?> getExternalConnection(
    String bssid,
    String uuid,
    DateTime dateTime,
  ) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
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

  Future<ModelTest?> getTestConnection(
    String bssid,
    String uuid,
    DateTime dateTime,
  ) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
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

  Future<List<AllSignalConnection>> getLevel(
    String bssid,
    String uuid,
    DateTime dateTime,
  ) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('signals');
      var data = await subRef
          .where("uuid", isEqualTo: uuid)
          .orderBy("time", descending: true)
          .limit(20)
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
    String bssid,
    String uuid,
    DateTime dateTime,
  ) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      var subRef = docRef.collection('accessPoints');
      var data = await subRef
          .where("uuid", isEqualTo: uuid)
          .orderBy("time", descending: true)
          .limit(20)
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

  Future<bool> deleteConnection(String bssid, String uuid) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var doc = fConnections.doc(id);
      await doc.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAnalysis(
    String bssid,
    String uuid,
    DateTime dateTime,
  ) async {
    try {
      var id = getIdConnection(bssid, uuid);
      var idAnalysis = getIdAnalysis(dateTime);
      var docRef = fAnalysis(id).doc(idAnalysis);
      await docRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
