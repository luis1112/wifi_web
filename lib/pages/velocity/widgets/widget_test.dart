import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class TestPageCustom extends StatefulWidget {
  final ModelTest? test;

  const TestPageCustom(this.test, {super.key});

  @override
  State<TestPageCustom> createState() => _TestPageCustomState();
}

class _TestPageCustomState extends State<TestPageCustom> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.test == null) {
      return const Center(child: Text("No hay información"));
    }
    ModelTest test = widget.test!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Test de velocidad".toUpperCase(),
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: 250.0,
            child: Row(
              children: [
                Expanded(
                  child: itemData(
                    'DESCARGA',
                    test.rateDownload,
                    test.unitDownload,
                    test.durationInMillisDownload,
                  ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: itemData(
                    'SUBIDA',
                    test.rateUpload,
                    test.unitUpload,
                    test.durationInMillisUpload,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

//
  Widget itemData(
    String title,
    double rate,
    String unit,
    int durationInMillis,
  ) {
    durationInMillis = durationInMillis;
    return Card(
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              getTransferRate(rate, unit),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (durationInMillis > 0) ...{
              Text(
                'Tiempo: ${(durationInMillis / 1000).toStringAsFixed(0)} sec(s)',
                style: const TextStyle(
                  fontSize: 10.0,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  String getTransferRate(double rate, String unit) {
    unit = unit[0].toUpperCase() + unit.substring(1);
    return "$rate $unit";
  }
}
