import 'package:ez_debt/src/cubit/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsOption {
  final String title;
  final IconData icon;
  final String subtitle;
  final String href;

  SettingsOption({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.href,
  });
}

final settingsGroups = {
  "General Settings": [
    SettingsOption(
      title: "Language",
      subtitle: "Change language",
      icon: Icons.translate_rounded,
      href: "/settings/language",
    ),
    SettingsOption(
      title: "Currency",
      subtitle: "Change currency",
      icon: Icons.attach_money_rounded,
      href: "/settings/language",
    ),
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
      href: "/settings/language",
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
    return VStack(
      [
        "Theme Settings".text.titleMedium(context).make().pOnly(
              left: 12.w,
              top: 18.h,
              bottom: 8.h,
            ),
        ListTile(
          leading: const Icon(Icons.contrast_rounded),
          title: "Enable Dark Mode".text.labelMedium(context).make(),
          subtitle: "Enable dark mode for the application"
              .text
              .bodySmall(context)
              .make(),
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
        ...settingsGroups.entries.map(
          (group) {
            return VStack(
              [
                group.key.text.titleMedium(context).make().pOnly(
                      left: 12.w,
                      top: 18.h,
                      bottom: 8.h,
                    ),
                ...group.value.map(
                  (option) => SettingsTile(option: option),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final SettingsOption option;
  const SettingsTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push(option.href);
      },
      leading: Icon(option.icon),
      title: option.title.text.labelMedium(context).make(),
      subtitle: option.subtitle.text.bodySmall(context).make(),
    );
  }
}
