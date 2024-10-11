import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/features/entries/view/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewEntryView extends StatelessWidget {
  const NewEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return EntryForm(
      onSave: (entry) {
        if (entry != null) {
          context.read<TenantCubit>().createNewEntry(entry);
          context.pop();
        }
      },
    );
  }
}
