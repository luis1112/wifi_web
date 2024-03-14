import 'package:pdf/widgets.dart';
import 'package:wifi_web/docs.dart';

Widget itemNetworksChanelPdf(List<ItemChartChanel> lineBarsData) {
  return Column(
    children: List.generate(lineBarsData.length, (index) {
      var item = lineBarsData[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          children: [
            Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                color: colorPdf(item.color),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                "${item.item.ssid} (${item.item.level})",
                style: const TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
      );
    }),
  );
}
