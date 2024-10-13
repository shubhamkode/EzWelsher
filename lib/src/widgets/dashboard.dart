import 'package:ez_debt/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class Dashboard extends StatelessWidget {
  final double recievedAmt;
  final double paidAmt;
  const Dashboard({
    super.key,
    required this.paidAmt,
    required this.recievedAmt,
  });

  @override
  Widget build(BuildContext context) {
    return HStack([
      HStack(
          axisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.spaceBetween,
          [
            ScoreCard(
              amount: recievedAmt,
              hint: "Recived",
            ).wOneForth(context),
            const Icon(Icons.remove_rounded),
            ScoreCard(
              amount: paidAmt * -1,
              hint: "Paid",
            ).wOneForth(context),
          ]).expand(),
      HStack([
        const Icon(Icons.arrow_forward_outlined),
        20.w.widthBox,
        ScoreCard(
          amount: recievedAmt - paidAmt,
          hint: "Balance",
        ).wOneForth(context),
      ])
    ]);
    // return HStack(
    //   axisSize: MainAxisSize.max,
    //   alignment: MainAxisAlignment.spaceBetween,
    //   [
    //     HStack(
    //       [
    //         ScoreCard(
    //           amount: recievedAmt,
    //           hint: "Recieved",
    //         ),
    //         10.w.widthBox,
    //         const Icon(Icons.remove_rounded),
    //         10.w.widthBox,
    //         ScoreCard(
    //           amount: paidAmt * -1,
    //           hint: "Sent",
    //         ),
    //       ],
    //     ),
    //     const Icon(Icons.arrow_forward_rounded),
    //     // 40.w.widthBox,
    //     ScoreCard(
    //       amount: recievedAmt - paidAmt,
    //       hint: "Balance",
    //     ),
    //   ],
    // );
  }
}

class ScoreCard extends StatelessWidget {
  final double amount;
  final String hint;
  const ScoreCard({
    super.key,
    required this.amount,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return VStack(
      crossAlignment: CrossAxisAlignment.center,
      [
        formatAmount(context, amount),
        "($hint)"
            .text
            .color(
              (amount).isNegative ? Vx.rose500 : Vx.emerald500,
            )
            .base
            .make(),
      ],
    );
  }
}
