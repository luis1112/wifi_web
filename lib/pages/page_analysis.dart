import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class PageAnalysis extends StatefulWidget {
  static String route = "analysis";

  const PageAnalysis({super.key});

  @override
  State<PageAnalysis> createState() => _PageAnalysisState();
}

class _PageAnalysisState extends State<PageAnalysis> {
  ProviderConnection pvC = ProviderConnection.of();
  ProviderLogin pvL = ProviderLogin.of();
  ProviderFirebase pvF = ProviderFirebase.of();
  UserModel? user;

  //args
  String bssid = "";
  String uuid = "";

  // dates
  DateTime dateFrom = DateTime.now();
  DateTime dateTo = DateTime.now();
  int intervalPerMonth = 1;

  bool get isCompleteInfo => bssid.trim().isNotEmpty && uuid.trim().isNotEmpty;

  initDates() {
    var now = DateTime.now();
    dateFrom = DateTime(now.year, now.month - intervalPerMonth, now.day - 1);
    dateTo = now.copyWith(hour: 23, minute: 59);
  }

  @override
  void initState() {
    initDates();
    Future.delayed(Duration.zero, () async {
      user = await pvL.getUser;
      if (user != null && isCompleteInfo) {
      } else {
        navG.pushNamedAndRemoveUntil(PagePrincipal.route, (route) => false);
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pvL = ProviderLogin.of(context);
    pvC = ProviderConnection.of(context);
    pvF = ProviderFirebase.of(context);
    var arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map) {
      bssid = parseString(arg["bssid"]);
      uuid = parseString(arg["uuid"]);
    }
    if (user == null) return const PageLoad();
    return Scaffold(
      appBar: AppBar(
        title: Text("${pvC.connection.ssid} - ${pvC.connection.bssid}"),
        backgroundColor: Colors.blueGrey[900],
        actions: actionsAppBar,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DialogDateFilter(
              intervalPerMonth: intervalPerMonth,
              onChanged: (v1, v2) {
                dateFrom = v1;
                dateTo = v2.copyWith(hour: 23, minute: 59);
              },
            ),
            Expanded(child: itemStreamBuilderConnections())
          ],
        ),
      ),
    );
  }

  Widget itemStreamBuilderConnections() {
    var accessC = AccessPointController();
    var id = accessC.getIdConnection(bssid, uuid);
    return StreamBuilder<QuerySnapshot>(
      stream: fAnalysis(id)
          .where("uuid", isEqualTo: uuid)
          .where('time',
              isGreaterThanOrEqualTo: dateFrom.millisecondsSinceEpoch)
          .where('time', isLessThanOrEqualTo: dateTo.millisecondsSinceEpoch)
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: loadCenter());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error de conexión'));
        }

        var documents = snapshot.data?.docs ?? [];

        if (!snapshot.hasData || documents.isEmpty) {
          return const Center(child: Text('No existe información'));
        }

        List<Analysis> list = documents
            .map((e) => Analysis.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        var groupedAnalyses = groupByDay(list);

        return SingleChildScrollView(
          child: Wrap(
            children: groupedAnalyses.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(maxWidth: 350.0),
                child: Card(
                  elevation: 2,
                  child: ExpansionTile(
                    title: Text(
                      'Fecha: ${UtilMethod.formatDateMonth(entry.key)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    children: entry.value.map((analysis) {
                      return ListTile(
                        title: Text(
                          "Hora: ${UtilMethod.formatDateHour(analysis.date)}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          navG.pushNamed(
                            PageInfo.route,
                            arguments: {
                              "bssid": bssid,
                              "uuid": uuid,
                              "time": analysis.time,
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Map<DateTime, List<Analysis>> groupByDay(List<Analysis> analyses) {
    Map<DateTime, List<Analysis>> groupedAnalyses = {};

    for (Analysis analysis in analyses) {
      // Truncate time information to group by day
      DateTime day =
          DateTime(analysis.date.year, analysis.date.month, analysis.date.day);

      // Check if the day already exists in the map
      if (groupedAnalyses.containsKey(day)) {
        groupedAnalyses[day]!.add(analysis);
      } else {
        groupedAnalyses[day] = [analysis];
      }
    }

    return groupedAnalyses;
  }
}
