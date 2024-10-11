import 'package:ez_debt/src/features/entries/view/edit_entry_view.dart';
import 'package:ez_debt/src/features/entries/view/new_entry_view.dart';
import 'package:ez_debt/src/features/settings/view/pages/backup_and_restore.dart';
import 'package:ez_debt/src/features/settings/view/settings_view.dart';
import 'package:ez_debt/src/features/tenant/view/new_tenant_view.dart';
import 'package:ez_debt/src/features/tenant/view/tenant_details_view.dart';
import 'package:ez_debt/src/features/tenant/view/tenant_profile_view.dart';
import 'package:ez_debt/src/shared/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: "/tenants",
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: "new",
          builder: (context, state) => const NewTenantView(),
        ),
        GoRoute(
          path: ":id",
          builder: (context, state) {
            return TenantDetailsView(
              tenantId: int.parse(state.pathParameters["id"]!),
            );
          },
          routes: [
            GoRoute(
              path: "edit",
              builder: (context, state) {
                return TenantProfileView(
                  tenantId: int.parse(state.pathParameters["id"] ?? "0"),
                );
              },
            )
          ],
        ),
      ],
    ),
    GoRoute(
      path: "/entries",
      builder: (context, state) => const Placeholder(),
      routes: [
        GoRoute(
          path: ":id/edit",
          builder: (context, state) => EditEntryView(
            entryId: int.parse(state.pathParameters["id"]!),
          ),
        ),
        GoRoute(
          path: "new",
          builder: (context, state) => const NewEntryView(),
        ),
      ],
    ),
    GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsView(),
      routes: [
        GoRoute(
          path: "backup",
          builder: (context, state) => const BackupAndRestore(),
        )
      ],
    ),
  ],
);
