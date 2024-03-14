import 'package:wifi_web/docs.dart';

class UserController {
  Future<UserModel?> getUserByUuid(String email) async {
    try {
      var querySnapshot = await fUsers.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<DeviceModel>> getDevicesByEmail(String email) async {
    try {
      var docRef = fUsers.doc(email);
      var subRef = docRef.collection('devices');
      var docs = (await subRef.get()).docs;
      var result = docs.map((e) {
        var eData = e.data();
        return DeviceModel.fromJson(eData);
      }).toList();
      return result;
    } catch (e) {
      return [];
    }
  }
}
