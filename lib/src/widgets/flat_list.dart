import 'package:flutter/material.dart';

class FlatList<T> extends StatelessWidget {
  final List<T> list;
  final Function(T item) widget;
  final Widget onEmpty;
  const FlatList({
    super.key,
    required this.list,
    required this.widget,
    required this.onEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return onEmpty;
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        return widget(list[index]);
      },
      itemCount: list.length,
    );
  }
}
