import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/entries/view/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:velocity_x/velocity_x.dart';

class EditEntryView extends StatelessWidget {
  final int entryId;
  const EditEntryView({
    super.key,
    required this.entryId,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<TenantCubit, TenantCubitState>(
      builder: (context, state) {
        if (state is TenantCubitLoaded) {
          final entry =
              state.tenant.entries.filter().idEqualTo(entryId).findFirstSync();
          return EntryForm(
            entry: entry,
            onSave: (entry) {
              if (entry != null) {
                context.read<TenantCubit>().updateEntry(entry);
                context.pop();
              }
            },
            onDelete: (int entryId) {
              context.read<TenantCubit>().deleteEntry(entryId);
              context.pop();
            },
          );
        }
        return const CircularProgressIndicator().centered();
      },
    );
  }
}
