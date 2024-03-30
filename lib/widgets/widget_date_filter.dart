import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

typedef ValueChangedDateFilter = void Function(
    DateTime dateFrom, DateTime dateTo);

class DialogDateFilter extends StatefulWidget {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final DateTime? currentDate;
  final int maxMonthsBack; //hasta cuantos meses maximos hacia atras
  final int intervalPerMonth; //intervalo de consulta por meses
  final ValueChangedDateFilter? onChanged;

  const DialogDateFilter({
    super.key,
    this.maxMonthsBack = 6,
    this.intervalPerMonth = 1,
    this.dateFrom,
    this.dateTo,
    this.currentDate,
    this.onChanged,
  });

  @override
  State<DialogDateFilter> createState() => _DialogDateFilterState();
}

class _DialogDateFilterState extends State<DialogDateFilter> {
  TextEditingController editFrom = TextEditingController();
  TextEditingController editTo = TextEditingController();
  DateTime currentDate = DateTime.now();
  late DateTime dateFromAux;
  late DateTime dateToAux;

  DateTime get firstDateInit {
    var month = currentDate.month - widget.maxMonthsBack;
    return currentDate.copyWith(month: month);
  }

  @override
  void initState() {
    initDates();
    setEditDates();
    // Future.delayed(Duration.zero,(){
    //   onChanged();
    // });
    super.initState();
  }

  initDates() {
    dateFromAux = currentDate.copyWith(
        month: currentDate.month - widget.intervalPerMonth,
        day: currentDate.day - 1);
    dateToAux = currentDate;
  }

  setEditDates() {
    editFrom.text = UtilMethod.formatDateMonth(dateFromAux);
    editTo.text = UtilMethod.formatDateMonth(dateToAux);
    setState(() {});
  }

  onChanged() {
    if (widget.onChanged != null) widget.onChanged!(dateFromAux, dateToAux);
  }

  @override
  Widget build(BuildContext context) {
    dateFromAux = widget.dateFrom ?? dateFromAux;
    dateToAux = widget.dateTo ?? dateToAux;
    currentDate = widget.currentDate ?? currentDate;
    //init
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InputField<DateTime>(
            controller: editFrom,
            title: "Fecha de inicio",
            firstDate: () => firstDateInit,
            valueSelect: dateFromAux,
            lastDate: () =>
                DateTime(currentDate.year, currentDate.month, currentDate.day),
            formatDate: (d) => UtilMethod.formatDateMonth(d),
            onChanged: (v) {
              dateFromAux = v;
              //date
              dateToAux = getDateTimeTo(dateFromAux, 1);
              onChanged();
              setEditDates();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InputField<DateTime>(
            controller: editTo,
            title: "Fecha fin",
            firstDate: () => getDateTimeTo(dateFromAux, 0),
            valueSelect: dateToAux,
            lastDate: () => getDateTimeTo(dateFromAux, 1),
            formatDate: (d) => UtilMethod.formatDateMonth(d),
            onChanged: (v) {
              dateToAux = v;
              onChanged();
              setEditDates();
            },
          ),
        ),
      ],
    );
  }

  DateTime getDateTimeTo(DateTime from, int type) {
    int numMonthMax = from.month + widget.intervalPerMonth;
    int numDayMax = from.day;
    int numYearMax = from.year;

    //controla el mes actual
    if (numMonthMax >= currentDate.month && currentDate.year == numYearMax) {
      numMonthMax = currentDate.month;
      numDayMax = currentDate.day;
    }
    DateTime dateReturn;
    if (type == 0) {
      int dayAux = from.day + 1;
      if (from.year == currentDate.year &&
          from.month == currentDate.month &&
          from.day == currentDate.day) {
        dayAux = from.day;
      }
      dateReturn = DateTime(from.year, from.month, dayAux);
    } else if (type == 1) {
      dateReturn = DateTime(numYearMax, numMonthMax, numDayMax);
    } else {
      dateReturn = from;
    }
    return dateReturn;
  }
}
