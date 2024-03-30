import 'package:wifi_web/docs.dart';

class Analysis {
  final int time;
  final DateTime date;
  final String uuid;

  Analysis({
    required this.time,
    required this.date,
    required this.uuid,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    var time = parseInt(json['time']);
    return Analysis(
      time: parseInt(json['time']),
      date: DateTime.fromMillisecondsSinceEpoch(time),
      uuid: parseString(json['uuid']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'uuid': uuid,
    };
  }
}
