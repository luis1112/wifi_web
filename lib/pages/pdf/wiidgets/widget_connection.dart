import 'package:pdf/widgets.dart';
import 'package:wifi_web/docs.dart';

Widget itemConnectionPdf(ItemConnection? c) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      itemTextGPdf("SSID:", c?.ssid),
      itemTextGPdf("MAC:", c?.bssid),
      itemTextGPdf("Señal:", "${c?.signal} dBm"),
      itemTextGPdf("Frecuencia:", c?.freq),
      itemTextGPdf("Ancho de banda:", c?.chanel),
      Divider(),
      itemTextGPdf("Dirección IP:", c?.ipV4),
      itemTextGPdf("Dirección IPV6:", c?.ipV6),
      itemTextGPdf("Gateway:", c?.gateway),
      itemTextGPdf("Broadcast:", c?.broadcast),
      itemTextGPdf("Máscara de red:", c?.submask),
      Divider(),
      itemTextGPdf("Latitud:", c?.latitude),
      itemTextGPdf("Longitud:", c?.longitude),
      itemTextGPdf("Distancia aproximada al router:", c?.distance),
    ],
  );
}
