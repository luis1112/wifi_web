import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PageTest extends StatefulWidget {
  const PageTest({super.key});

  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  ProviderConnection pvC = ProviderConnection.of();

  @override
  Widget build(BuildContext context) {
    pvC = ProviderConnection.of(context, true);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            TestPageCustom(pvC.test),
          ],
        ),
      ),
    );
  }
}
