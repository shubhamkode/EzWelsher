import 'package:ez_debt/dependency_container.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
      automaticallyImplyLeading: false,
      title: "Backup and Restore".text.labelLarge(context).make(),
      actions: [
        CloseButton(),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: const Divider(),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return VStack(
      [
        ListTile(
          leading: Icon(
            Icons.delete_rounded,
            color: context.colors.error,
          ).pOnly(left: 4.w),
          title: "Delete all data"
              .text
              .color(context.colors.error)
              .labelMedium(context)
              .make(),
          onTap: () {
            s1<DatabaseService>().deleteDatabase();
            context.replace("/");
          },
        ),
      ],
    );
  }
}
