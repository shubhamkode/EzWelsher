import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

class BackupAndRestore extends StatelessWidget {
  const BackupAndRestore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: "Backup and Restore".text.labelLarge(context).make(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: const Divider(),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return VStack([
      "Backup all your data".text.labelMedium(context).make(),
      5.h.heightBox,
      "Backup all your tenants and entries into local storage or your google account storage"
          .text
          .sm
          .color(context.colors.onSurface)
          .make()
    ]).pSymmetric(
      v: 16.h,
      h: 16.w,
    );
  }
}
