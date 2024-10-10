import 'dart:typed_data';
import 'dart:html' as html;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as uhtml;
import 'package:wifi_web/docs.dart';

class PageInform extends StatefulWidget {
  static String route = "PageInform";

  const PageInform({super.key});

  @override
  State<PageInform> createState() => _PageInformState();
}

class _PageInformState extends State<PageInform> {
  ProviderConnection pvC = ProviderConnection.of();
  ScreenshotController sVelocity = ScreenshotController();
  ScreenshotController sChanel = ScreenshotController();
  ScreenshotController sSignal = ScreenshotController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    pvC.typeChanel = null;
    pvC.typeSignal = null;

    return Scaffold(
      body: itemPdf(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BtnC(
        title: "Exportar PDF",
        onTap: () async {
          var args = Tuple9(
            pvC.connection,
            pvC.external,
            sVelocity,
            sChanel,
            sSignal,
            pvC.lineBarsData,
            pvC.listSignal,
            ProviderFirebase.of().dateTime,
            pvC.test,
          );
          onLoad(true);
          await getPathPdf(args);
          onLoad(false);
        },
      ),
    );
  }

  Widget itemPdf() {
    return MainPdf(
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: SizedBox(
          width: 800.0,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                itemFrontPage(),
                itemTextTitle("Datos de conexión"),
                itemConnection(pvC.connection),
                itemTextTitle("Datos externos"),
                itemExternalData(pvC.external),
                itemTextTitle("Gráfica de intensidad"),
                Screenshot(
                  controller: sVelocity,
                  child: AspectRatio(
                    aspectRatio: 1.9,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: itemChartVelocity(
                          pvC.listPoints, pvC.level, pvC.limitCount),
                    ),
                  ),
                ),
                itemTextTitle("Test de velocidad"),
                itemTest(pvC.test),
                itemTextTitle("Gráfica de canales"),
                Screenshot(
                  controller: sChanel,
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20.0, top: 20.0, left: 20.0),
                      child: LineChart(itemChartChanel(pvC.lineBarsData)),
                    ),
                  ),
                ),
                itemTextTitle("Puntos de red para canales"),
                itemNetworksChanel(pvC.lineBarsData),
                itemTextTitle("Gráfica de señal"),
                Screenshot(
                  controller: sSignal,
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: itemChartSignal(pvC.listSignal, pvC.limitCount),
                    ),
                  ),
                ),
                itemTextTitle("Puntos de red para señal"),
                itemNetworksSignal(pvC.listSignal),
                const SizedBox(height: 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemFrontPage() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/image/icon.png",
            height: 60.0,
          ),
          itemTextTitle("Universidad Nacional de Loja"),
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              '"Análisis Estadístico de la Red Wi-Fi: Puntos de Acceso y Conectividad"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          itemTextG("FECHA Y HORA:",
              UtilMethod.formatDateMonthHour(ProviderFirebase.of().dateTime)),
          const Text(
            "LOJA - ECUADOR",
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget itemTextTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Future<String?> getPathPdf(
    Tuple9<
            ItemConnection,
            ExternalConnection?,
            ScreenshotController,
            ScreenshotController,
            ScreenshotController,
            List<ItemChartChanel>,
            List<ItemChartSignal>,
            DateTime,
            ModelTest?>
        args) async {
  ItemConnection connection = args.item1;
  ExternalConnection? redInfo = args.item2;
  ScreenshotController sVelocity = args.item3;
  ScreenshotController sChanel = args.item4;
  ScreenshotController sSignal = args.item5;
  List<ItemChartChanel> lineBarsData = args.item6;
  List<ItemChartSignal> listSignal = args.item7;
  DateTime dateTime = args.item8;
  ModelTest? test = args.item9;
  return await generatePDF(connection, redInfo, sVelocity, sChanel, sSignal,
      lineBarsData, listSignal, dateTime, test);
}

Future<String?> generatePDF(
  ItemConnection connection,
  ExternalConnection? redInfo,
  ScreenshotController sVelocity,
  ScreenshotController sChanel,
  ScreenshotController sSignal,
  List<ItemChartChanel> lineBarsData,
  List<ItemChartSignal> listSignal,
  DateTime dateTime,
  ModelTest? test,
) async {
  try {
    final pdf = pw.Document();

    var widgetFrontPage = await itemFrontPagePdf(dateTime);

    pdf.addPage(itemPagePdf(
      [widgetFrontPage],
      mainAxisAlignment: pw.MainAxisAlignment.center,
    ));

    // Create a PDF page
    pdf.addPage(itemPagePdf([
      itemTextTitlePdf("Datos de conexión"),
      itemConnectionPdf(connection),
    ]));
    pdf.addPage(itemPagePdf([
      itemTextTitlePdf("Datos externos"),
      itemExternalDataPdf(redInfo),
    ]));
    var bVelocity = await sVelocity.capture();
    if (bVelocity != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de intensidad"),
        itemImagePdf(bVelocity, width: 500.0, height: 600.00),
      ]));
    }
    var bChanel = await sChanel.capture();
    if (test != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Test de velocidad"),
        itemTestPdf(test),
      ]));
    }
    if (bChanel != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de señal"),
        itemImagePdf(bChanel),
      ]));
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Puntos de red para canales"),
        itemNetworksChanelPdf(lineBarsData),
      ]));
    }
    var bSignal = await sSignal.capture();
    if (bSignal != null) {
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Gráfica de señal"),
        itemImagePdf(bSignal),
      ]));
      pdf.addPage(itemPagePdf([
        itemTextTitlePdf("Puntos de red para señal"),
        itemNetworksChanelPdf(lineBarsData),
      ]));
    }

    // Save the PDF document to a file
    final Uint8List bytes = await pdf.save();

    downloadPDF(bytes, dateTime);
    return "";
  } catch (er) {
    printC(er);
    return null;
  }
}

void downloadPDF(Uint8List bytes, DateTime dateTime) {
  // Convierte los datos de Uint8List a Blob
  var blob = uhtml.Blob([bytes]);

  // Crea un objeto URL a partir del Blob
  var url = uhtml.Url.createObjectUrlFromBlob(blob);

  // Crea un enlace html para descargar el PDF
  html.AnchorElement(href: url)
    ..setAttribute("download",
        "InformeWifi${UtilMethod.formatDateMonthHour(dateTime)}.pdf") // Nombre del archivo a descargar
    ..click(); // Simula el clic en el enlace

  // Limpia la URL del objeto después de que se complete la descarga
  uhtml.Url.revokeObjectUrl(url);
}

class Tuple9<A, B, C, D, E, F, G, H, I> {
  final A item1;
  final B item2;
  final C item3;
  final D item4;
  final E item5;
  final F item6;
  final G item7;
  final H item8;
  final I item9;

  const Tuple9(this.item1, this.item2, this.item3, this.item4, this.item5,
      this.item6, this.item7, this.item8, this.item9);
}
