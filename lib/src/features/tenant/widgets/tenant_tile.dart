import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:ez_debt/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class TenantTile extends StatelessWidget {
  final Tenant tenant;
  const TenantTile({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    final transactionTotal = tenant.entries.fold<double>(
      0,
      (aggr, prev) {
        if (prev.type == EntryType.paid) {
          return aggr - (prev.amount ?? 0);
        }
        return aggr + (prev.amount ?? 0);
      },
    );
    return ListTile(
      onTap: () {
        context.read<TenantCubit>().fetchTenant(tenant.id);
        context.push("/tenants/${tenant.id}");
      },
      leading: CircleAvatar(
        child: tenant.name!.isNotEmpty
            ? (tenant.name?[0].text.make())
            : "".text.make(),
      ).onTap(() {
        context.read<TenantCubit>().fetchTenant(tenant.id);
        context.push("/tenants/${tenant.id}/edit");
      }),
      title: tenant.name?.text.labelMedium(context).make(),
      subtitle: formatAmount(context, transactionTotal),
      trailing: Icon(
        Icons.chevron_right_outlined,
        size: 24.h,
      ),
    );
  }
}
