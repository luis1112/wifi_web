import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:wifi_web/docs.dart';

Future<Widget> itemFrontPagePdf(DateTime dateTime) async {
  var widgetImage = await itemAssetsImagePdf(
    "assets/image/Icon-192.png",
    height: 60.0,
    width: 60.0,
  );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      widgetImage,
      itemTextTitlePdf("Universidad Nacional de Loja"),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Text(
          '"Análisis Estadístico de la Red Wi-Fi: Puntos de Acceso y Conectividad"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      itemTextGPdf("FECHA Y HORA:", UtilMethod.formatDateMonthHour(dateTime)),
      Text(
        "LOJA - ECUADOR",
        style: const TextStyle(fontSize: 20.0),
      ),
    ],
  );
}
