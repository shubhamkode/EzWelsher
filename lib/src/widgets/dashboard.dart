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
    return HStack(
      axisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.spaceBetween,
      [
        HStack(
          [
            VStack(
              crossAlignment: CrossAxisAlignment.center,
              [
                formatAmount(context, recievedAmt),
                "(Recieved)".text.emerald500.base.make(),
              ],
            ),
            10.w.widthBox,
            const Icon(Icons.remove_rounded),
            10.w.widthBox,
            VStack(
              crossAlignment: CrossAxisAlignment.center,
              [
                formatAmount(context, paidAmt * -1),
                "(Sent)".text.base.rose500.make(),
              ],
            ),
          ],
        ),
        const Icon(Icons.arrow_forward_rounded),
        // 40.w.widthBox,
        VStack(
          crossAlignment: CrossAxisAlignment.center,
          [
            formatAmount(context, recievedAmt - paidAmt),
            "(Balance)"
                .text
                .color(
                  (recievedAmt - paidAmt).isNegative
                      ? Vx.rose500
                      : Vx.emerald500,
                )
                .base
                .make(),
          ],
        ),
      ],
    );
  }
}
