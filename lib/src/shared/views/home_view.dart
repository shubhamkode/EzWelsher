import 'package:ez_debt/dependency_container.dart';
import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:ez_debt/src/features/tenant/widgets/tenant_tile.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:ez_debt/src/widgets/dashboard.dart';
import 'package:ez_debt/src/widgets/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: "EzWelsher".text.labelLarge(context).make(),
      actions: [
        IconButton(
          onPressed: () {
            context.push("/settings");
          },
          icon: const Icon(
            Icons.manage_accounts_rounded,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: const Divider(),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return BlocListener<TenantCubit, TenantState>(
      listenWhen: (previous, current) => current != previous,
      listener: (context, state) {
        setState(() {});
      },
      child: VStack(
        [
          StreamBuilder(
            stream: s1<DatabaseService>().listenToEntries(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final entries = snapshot.data!;
                double getAmountFor(EntryType type) {
                  return (entries.filter((entry) => entry.type == type))
                      .fold<double>(
                          0, (prev, curr) => prev + (curr.amount ?? 0));
                }

                return Dashboard(
                  paidAmt: getAmountFor(EntryType.paid),
                  recievedAmt: getAmountFor(EntryType.recieved),
                ).pOnly(
                  left: 12.w,
                  top: 16.h,
                  bottom: 8.h,
                  right: 12.w,
                );
              } else {
                return const Dashboard(
                  paidAmt: 0,
                  recievedAmt: 0,
                ).pOnly(
                  left: 12.w,
                  top: 16.h,
                  bottom: 8.h,
                  right: 12.w,
                );
              }
            },
          ),
          12.h.heightBox,
          StreamBuilder(
            stream: s1<DatabaseService>().listenToTenants(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tenants = snapshot.data!;
                return FlatList(
                  list: tenants,
                  widget: (tenant) => TenantTile(tenant: tenant),
                  onEmpty: "No tenants found"
                      .text
                      .bodyMedium(context)
                      .color(context.colors.onSurface.withOpacity(0.5))
                      .makeCentered(),
                );
              }

              return const CircularProgressIndicator().centered();
            },
          ).expand(),
        ],
      ),
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final tenant = await context.push<Tenant>("/tenants/new");
        if (tenant != null) {
          s1<DatabaseService>().createNewTenant(tenant: tenant);
          setState(() {});
        }
      },
      child: const Icon(
        Icons.person_add_outlined,
      ),
    );
  }
}
