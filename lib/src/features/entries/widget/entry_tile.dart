import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class EntryTile extends StatelessWidget {
  final Entries entry;
  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Icon(
      //   entry.type == EntryType.paid
      //       ? Icons.trending_up_rounded
      //       : Icons.trending_down_rounded,
      // ),
      onTap: () {
        context.push("/entries/${entry.id}/edit");
      },
      subtitle: (entry.type != EntryType.paid ? "(Recieved)" : "(Paid)")
          .text
          .base
          .make(),
      title: entry.date.toString().split(" ")[0].text.lg.semiBold.make(),
      trailing: formatAmount(
        context,
        entry.amount! * (entry.type == EntryType.paid ? -1 : 1),
      ),
    );
  }
}
