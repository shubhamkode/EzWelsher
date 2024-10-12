import 'package:ez_debt/dependency_container.dart';
import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/tenant/view/tenant_form.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class TenantProfileView extends StatelessWidget {
  final int? tenantId;
  const TenantProfileView({
    super.key,
    this.tenantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantCubit, TenantState>(
      builder: (ctx, state) {
        return state.when(
          onErr: (errMsg) => const CircularProgressIndicator().centered(),
          onLoading: () => const CircularProgressIndicator().centered(),
          onData: (tenant) {
            return TenantForm(
              tenant: state.data,
              onSave: (tenant) {
                if (tenant != null) {
                  s1<DatabaseService>().createNewTenant(tenant: tenant);
                  // context.read<TenantCubit>().invalidateSelf();
                  context.pop();
                }
              },
              onDelete: () {
                s1<DatabaseService>().deleteTenant(state.data!.id);
                context.read<TenantCubit>().reset();
                context.go("/");
              },
            );
          },
        );
      },
    );
  }
}
