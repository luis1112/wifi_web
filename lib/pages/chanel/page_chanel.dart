import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PageChanel extends StatefulWidget {
  const PageChanel({super.key});

  @override
  State<PageChanel> createState() => _PageChanelState();
}

class _PageChanelState extends State<PageChanel> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: BtnC(
                      title: "2.4 GHZ",
                      isActive: pvC.typeChannel == TypeChanel.ghz2,
                      onTap: () {
                        if (pvC.typeChannel == TypeChanel.ghz2) {
                          pvC.typeChannel = null;
                        } else {
                          pvC.typeChannel = TypeChanel.ghz2;
                        }
                        pvC.obtainChartChanel();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: BtnC(
                      title: "5GHZ",
                      isActive: pvC.typeChannel == TypeChanel.ghz5,
                      onTap: () {
                        if (pvC.typeChannel == TypeChanel.ghz5) {
                          pvC.typeChannel = null;
                        } else {
                          pvC.typeChannel = TypeChanel.ghz5;
                        }
                        pvC.obtainChartChanel();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: BtnC(
                      title: pvC.isActiveNetwork ? "Ocultar" : "Redes",
                      isActive: pvC.isActiveNetwork,
                      onTap: () {
                        pvC.isActiveNetwork = !pvC.isActiveNetwork;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Stack(
                children: [
                  SizedBox(
                    height: getHeightGraph(context),
                    width: getWidthGraph(context),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: LineChart(itemChartChanel(pvC.lineBarsData, pvC.typeChannel)),
                    ),
                  ),
                  if (pvC.isActiveNetwork)
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      alignment: Alignment.topRight,
                      child: Card(
                        elevation: 5.0,
                        child: Container(
                          height: 200.0,
                          width: 200.0,
                          padding: const EdgeInsets.all(5.0),
                          child: SingleChildScrollView(
                            child: itemNetworksChanel(pvC.lineBarsData),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
