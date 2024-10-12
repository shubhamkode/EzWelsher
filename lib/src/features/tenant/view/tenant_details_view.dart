import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/entries/widget/entry_tile.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:ez_debt/src/widgets/dashboard.dart';
import 'package:ez_debt/src/widgets/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

enum EntrySort { asc, desc }

class TenantDetailsView extends StatefulWidget {
  final int tenantId;
  const TenantDetailsView({super.key, required this.tenantId});

  @override
  State<TenantDetailsView> createState() => _TenantDetailsViewState();
}

class _TenantDetailsViewState extends State<TenantDetailsView> {
  EntrySort sortType = EntrySort.desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<TenantCubit, TenantState>(
        builder: (context, state) {
          return state.when(
            onLoading: () => const CircularProgressIndicator().centered(),
            onErr: (errMsg) => const CircularProgressIndicator().centered(),
            onData: (tenant) {
              return _buildBody(
                context,
                tenant: tenant,
              );
            },
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return const TenantAppBar();
  }

  _buildBody(BuildContext context, {required Tenant tenant}) {
    final List<Entries> entries =
        tenant.entries.filter().sortByDateDesc().findAllSync().toList();

    double getAmountFor(EntryType type) {
      return entries.filter((entry) => entry.type == type).fold<double>(
            0,
            (prev, curr) => prev + (curr.amount ?? 0),
          );
    }

    return VStack(
      [
        Dashboard(
          paidAmt: getAmountFor(EntryType.paid),
          recievedAmt: getAmountFor(EntryType.recieved),
        ).pOnly(
          left: 24.w,
          top: 16.h,
          bottom: 8.h,
          right: 24.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.picture_as_pdf_outlined,
              ),
            ),
            IconButton(
              onPressed: () {
                if (sortType == EntrySort.asc) {
                  sortType = EntrySort.desc;
                } else {
                  sortType = EntrySort.asc;
                }
                setState(() {});
              },
              icon: const Icon(
                Icons.sort_rounded,
              ),
            ),
          ],
        ),
        _buildEntries(entries).expand(),
      ],
    );
  }

  Widget _buildEntries(List<Entries> entries) {
    return FlatList(
      list: sortType == EntrySort.asc ? entries.reversed.toList() : entries,
      widget: (entry) => EntryTile(entry: entry),
      onEmpty: VStack(
        crossAlignment: CrossAxisAlignment.center,
        [
          "No entries found"
              .text
              .bodyMedium(context)
              .color(context.colors.onSurface.withOpacity(0.5))
              .make(),
          "( Add new entry to get started )"
              .text
              .base
              .color(context.colors.onSurface.withOpacity(0.5))
              .make(),
        ],
      ).centered(),
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push("/entries/new");
      },
      child: const Icon(Icons.add),
    );
  }
}

class TenantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TenantAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantCubit, TenantState>(
      builder: (context, state) {
        return state.when(
          onErr: (errMsg) => "Something Went Wrong".text.makeCentered(),
          onLoading: () => AppBar(),
          onData: (tenant) {
            return AppBar(
              forceMaterialTransparency: true,
              leadingWidth: 70.w,
              leading: Row(
                children: [
                  const Icon(Icons.arrow_back).pOnly(left: 8.w, right: 4.w),
                  CircleAvatar(
                    child: tenant.name?[0].text.medium.make(),
                  )
                ],
              ).onTap(context.pop),
              title: "${tenant.name}"
                  .text
                  .labelLarge(context)
                  .make()
                  .wFull(context)
                  .onTap(() {
                context.push("/tenants/${tenant.id}/edit");
              }),
              actions: [
                IconButton(
                  onPressed: () async {
                    final url = Uri.parse("tel:${tenant.contact}");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(
                    Icons.call_outlined,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO:- Set Notification Reminder for a tenant
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.h),
                child: const Divider(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
