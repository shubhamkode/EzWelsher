import 'package:ez_debt/src/features/tenant/view/tenant_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewTenantView extends StatelessWidget {
  const NewTenantView({super.key});

  @override
  Widget build(BuildContext context) {
    return TenantForm(
      onSave: (tenant) {
        context.pop(tenant);
      },
    );
  }
}
