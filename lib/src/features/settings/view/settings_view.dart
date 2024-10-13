import 'package:ez_debt/dependency_container.dart';
import 'package:ez_debt/src/cubit/settings/settings_cubit.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:ez_debt/src/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsOption {
  final String title;
  final IconData icon;
  final String subtitle;
  final String? href;
  final Function(BuildContext context)? onTap;
  final Widget? trailing;

  SettingsOption({
    required this.title,
    required this.icon,
    required this.subtitle,
    this.href,
    this.onTap,
    this.trailing,
  });
}

final settingsGroups = {
  "Theme Settings": [
    SettingsOption(
      title: "Enable Dark Mode",
      subtitle: "Enable dark mode for the application",
      icon: Icons.contrast_rounded,
      onTap: (context) async {
        await context.read<SettingsCubit>().toggleDarkMode();
      },
      trailing: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.when(
            onData: (data) {
              return Switch(
                value: data.isDarkModeEnabled,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().toggleDarkMode();
                },
              );
            },
          );
        },
      ),
    ),
  ],
  "General Settings": [
    SettingsOption(
      title: "DateFormat",
      subtitle: "Select date format",
      icon: Icons.event_rounded,
      href: "/settings/language",
    ),
    SettingsOption(
      title: "Backup & Restore",
      subtitle: "Backup Progress on google drive",
      icon: Icons.backup_rounded,
      href: "/settings/backup",
    ),
    SettingsOption(
      title: "Reset Application",
      subtitle: "Erase all data and reset this application",
      icon: Icons.restart_alt_rounded,
      // href: "/settings/language",
      onTap: (context) {
        showDialog(
          context: context,
          builder: (ctx) {
            return getAlertDialog(
              title: Text(
                "Are you Sure?",
                style: ctx.textTheme.titleMedium,
              ),
              subtitle: Text(
                "All your data will be deleted forever and you won't be able to recover your data.",
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant.withOpacity(0.8),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ctx.pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    s1<DatabaseService>().deleteDatabase();
                    ctx.pop();
                    // context.go("/");
                  },
                  child: const Text("Sure"),
                ),
              ],
            );
          },
        );
      },
    ),
  ],
  "Support Us": [
    SettingsOption(
      title: "Rate Us",
      subtitle: "Feel free to leave us a review",
      icon: Icons.star_rounded,
      href: "/settings/review",
    ),
    SettingsOption(
      title: "Share App",
      subtitle: "Share this app with your friends",
      icon: Icons.share_rounded,
      href: "/settings/share",
    ),
  ]
};

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: "Settings".text.labelLarge(context).make(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: const Divider(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final settingTitles = settingsGroups.keys.toList();

    List<SettingsOption> getOptions(String title) {
      return settingsGroups[title]!;
    }

    return VStack(
      [
        ListView.builder(
          shrinkWrap: true,
          itemCount: settingTitles.length,
          itemBuilder: (context, index) {
            final options = getOptions(settingTitles[index]);

            return VStack(
              [
                settingTitles[index].text.titleMedium(context).make().pOnly(
                      left: 12.w,
                      top: 18.h,
                      bottom: 8.h,
                    ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) => SettingsTile(
                    option: options[index],
                  ),
                ),
              ],
            );
          },
        ).expand(),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final SettingsOption option;
  const SettingsTile({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (option.href != null) {
          context.push(option.href!);
          return;
        } else if (option.onTap != null) {
          option.onTap!(context);
        }
      },
      leading: Icon(option.icon),
      title: option.title.text.labelMedium(context).make(),
      subtitle: option.subtitle.text.bodySmall(context).make(),
      trailing: option.trailing,
    );
  }
}

// builder: (ctx) => getalertdialog(
//     title: Text(
//       'Delete entry?',
//       style: context.textTheme.titleMedium,
//     ),
//     subtitle: Text(
//       "Selected entry would be deleted and won't be recoverable.",
//       style: context.textTheme.bodySmall?.copyWith(
//         color: context.colors.onSurfaceVariant
//             .withOpacity(0.8),
//       ),
//     ),
//     actions: [
//       TextButton(
//         onPressed: () {
//           ctx.pop();
//         },
//         child: const Text("Cancel"),
//       ),
//       TextButton(
//         onPressed: () {
//           ctx.pop();
//           widget.onDelete!(widget.entry!.id);
//         },
//         child: const Text("Sure"),
//       )
//     ]),
