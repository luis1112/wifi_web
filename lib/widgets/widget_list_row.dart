import 'package:flutter/material.dart';
import 'package:wifi_web/docs.dart';

class ListRowC extends StatelessWidget {
  final List<Widget>? children;
  final int row;
  final bool isExpanded;
  final MainAxisAlignment? mainAxisAlignment;

  const ListRowC({
    super.key,
    this.children,
    this.row = 3,
    this.isExpanded = true,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = children ?? [];
    List<Widget> widgetsColumn = [];
    List<Widget> widgetsRow = [];
    Widget empty = Container();
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      widgetsRow.add(isExpanded ? Expanded(child: item) : item);
      if (widgetsRow.length == row || items.length == (i + 1)) {
        if (items.length == (i + 1) && widgetsRow.length < row) {
          List.generate(row - widgetsRow.length, (index) {
            widgetsRow.add(isExpanded ? Expanded(child: empty) : empty);
          });
        }
        widgetsColumn.add(Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: widgetsRow,
        ));
        widgetsRow = [];
      }
    }
    return Column(children: widgetsColumn);
  }
}

typedef IndexedStringTitle<T> = String Function(T);

class ListRowItems<T> extends StatelessWidget {
  final List<T> list;
  final T? valueSelect;
  final ValueChanged<T>? onChanged;
  final IndexedStringTitle<T> title;
  final bool isExpanded;

  const ListRowItems({
    super.key,
    required this.list,
    required this.title,
    this.valueSelect,
    this.onChanged,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded) return Expanded(child: itemList());
    return itemList();
  }

  Widget itemList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(list.length, (index) {
          var item = list[index];
          return Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: BtnCSelect(
              title: title(item),
              isSelect: valueSelect == item,
              // radius: 5.0,
              onTap: () {
                if (onChanged != null) onChanged!(item);
              },
            ),
          );
        }),
      ),
    );
  }
}
