import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget formatAmount(context, final double amount) {
  return "Rs. ${amount.abs().toString().numCurrency}"
      .text
      .color(amount.isNegative ? Vx.rose500 : Vx.emerald500)
      .lg
      .semiBold
      .make();
}

AlertDialog getAlertDialog({
  required Widget title,
  Widget? subtitle,
  List<Widget> actions = const [],
}) {
  return AlertDialog(
    title: title,
    content: subtitle,
    actions: actions,
  );
}
