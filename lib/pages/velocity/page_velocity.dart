import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PageVelocity extends StatefulWidget {
  const PageVelocity({super.key});

  @override
  State<PageVelocity> createState() => _PageVelocityState();
}

class _PageVelocityState extends State<PageVelocity> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: getHeightGraph(context),
                width: getWidthGraph(context),
                child:
                    itemChartVelocity(pvC.listPoints, pvC.level, pvC.limitCount),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
