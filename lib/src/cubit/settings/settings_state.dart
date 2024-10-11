part of 'settings_cubit.dart';

class Settings {
  final bool isDarkModeEnabled;

  const Settings({
    this.isDarkModeEnabled = false,
  });
}

@immutable
sealed class SettingsState {
  // final SettingsModel settings;
  final Settings appSettings;

  const SettingsState({
    required this.appSettings,
  });

  // const SettingsState({required this.settings});
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required super.appSettings,
  });
}
