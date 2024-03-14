import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

Widget itemConnection(ItemConnection? c) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      itemTextG("SSID:", c?.ssid),
      itemTextG("MAC:", c?.bssid),
      itemTextG("Señal:", "${c?.signal} dBm"),
      itemTextG("Frecuencia:", c?.freq),
      itemTextG("Ancho de banda:", c?.chanel),
      const DividerC(),
      itemTextG("Dirección IP:", c?.ipV4),
      itemTextG("Dirección IPV6:", c?.ipV6),
      itemTextG("Gateway:", c?.gateway),
      itemTextG("Broadcast:", c?.broadcast),
      itemTextG("Máscara de red:", c?.submask),
      const DividerC(),
      itemTextG("Latitud:", c?.latitude),
      itemTextG("Longitud:", c?.longitude),
      itemTextG("Distancia aproximada al router:", c?.distance),
    ],
  );
}

Widget itemTextG(String? label, String? text) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label ?? "",
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        Text(
          text ?? "",
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}

class DividerC extends StatelessWidget {
  const DividerC({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, color: Theme.of(context).primaryColor);
  }
}
