import 'package:intl/intl.dart';

class UtilMethod {
  static List<String> listMonth = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  ];

  static String formatDateMonth(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var month = listMonth[dateTime.month - 1].substring(0, 3);
    var dateStr = '${dateTime.day}/$month/${dateTime.year}';
    return dateStr.replaceAll('-', '/');
  }

  static String formatDateMontYear(DateTime? date) {
    if (date == null) return "";
    date = date.toLocal();
    var array = formatDateMonth(date).split("/");
    return "${array[1].toUpperCase()}.${array[2].substring(array[2].length - 2, array[2].length)}";
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "";
    date = date.toLocal();
    var dateStr = DateFormat('dd-MM-yyyy').format(date);
    return dateStr.replaceAll("-", "/");
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var dateStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return dateStr.toUpperCase();
  }

  static String formatDateHour(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var dateStr = DateFormat('HH:mm:ss').format(dateTime);
    return dateStr.toLowerCase();
  }

  static String formatDateTimeT(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var dateStr = DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
    return dateStr.toUpperCase();
  }

  static String formatDateMonthOnlyHour(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var hourStr = DateFormat('HH:mm').format(dateTime);
    var dateStr = formatDateMonth(dateTime);
    return "$dateStr $hourStr";
  }

  static String formatDateMonthHour(DateTime? dateTime) {
    if (dateTime == null) return "";
    dateTime = dateTime.toLocal();
    var hourStr = DateFormat('HH:mm:ss').format(dateTime);
    var dateStr = formatDateMonth(dateTime);
    return "$dateStr $hourStr";
  }

  static bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool validateRegex(String value, String pattern) {
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static String formatStringMayMin(String? v) {
    try {
      String value = v ?? "";
      String result = '';
      if (value.isNotEmpty) {
        var array = value.split(' ');
        String valueReturn = '';
        for (var e in array) {
          valueReturn +=
              '${e[0].toUpperCase()}${e.substring(1).toLowerCase()} ';
        }
        result = valueReturn.trim();
      }
      return result;
    } catch (err) {
      return v ?? "";
    }
  }

  static String maskNumber(
    String? number, {
    int init = 2,
    int end = 2,
    String mask = '*',
  }) {
    number = (number ?? "").trim();
    if (number.isEmpty) return number;
    try {
      if (init < 0 && end < 0) return number;
      if (number.length < 5) return number;
      String masked = number.substring(0, init);
      masked += List.filled(number.length - init - end, mask).join();
      masked += number.substring(number.length - end);
      return masked;
    } catch (err) {
      return number;
    }
  }

  static String maskEmail(String? email) {
    email = (email ?? "").trim();
    if (email.isEmpty) return email;
    try {
      var split = email.split("@");
      return "${maskNumber(split[0])}@${split[1]}";
    } catch (err) {
      return email;
    }
  }

  static String getPref(String? val) {
    String v = (val ?? "").trim();
    if (v.isEmpty) return "";
    var array = v.split(" ");
    if (array.length == 1) return array[0].substring(0, 1);
    if (array.length == 2) {
      return array[0].substring(0, 1) + array[1].substring(0, 1);
    }
    if (array.length > 2) {
      return array[0].substring(0, 1) + array[2].substring(0, 1);
    }
    return "";
  }
}
