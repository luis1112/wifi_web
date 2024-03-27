import 'package:flutter/cupertino.dart';
import 'package:wifi_web/docs.dart';

Widget itemExternalData(ExternalConnection? redInfo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      ...getExternal1(redInfo),
      const DividerC(),
      ...getExternal2(redInfo),
    ],
  );
}

List<Widget> getExternal1(ExternalConnection? redInfo) {
  ConnectionRedInfo? connection = redInfo?.connection;
  return [
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
