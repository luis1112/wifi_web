import 'package:flutter/cupertino.dart';
import 'package:wifi_web/docs.dart';

Widget itemExternalData(ExternalConnection? redInfo) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...getExternal2(redInfo),
      ],
    ),
  );
}

List<Widget> getExternal1(ExternalConnection? redInfo, String? getTypeConnection) {
  ConnectionRedInfo? connection = redInfo?.connection;
  return [
    if (getTypeConnection != null)
      itemTextG("Tipo de conexión:", getTypeConnection),
    itemTextG("IP Pública:", redInfo?.ip ?? "---"),
    itemTextG("ISP:", connection?.isp ?? "---"),
    itemTextG("Dominio:", connection?.domain ?? "---"),
    itemTextG("ASN:", connection?.asn.toString() ?? "---"),
  ];
}

List<Widget> getExternal2(ExternalConnection? redInfo) {
  return [
    itemTextG(
      "Continente:",
      "${redInfo?.continent ?? "---"} "
          "(${redInfo?.continentCode ?? "---"})",
    ),
    itemTextG(
      "País:",
      "${redInfo?.country ?? "---"} "
          "(${redInfo?.countryCode ?? "---"})",
    ),
    itemTextG("Capital:", redInfo?.capital ?? "---"),
    itemTextG("Ciudad:", redInfo?.city ?? "---"),
    itemTextG(
      "Región:",
      "${redInfo?.region ?? "---"} "
          "(${redInfo?.regionCode ?? "---"})",
    ),
    itemTextG("Latitud:", redInfo?.latitude.toString() ?? "---"),
    itemTextG("Longitud:", redInfo?.longitude.toString() ?? "---"),
  ];
}
