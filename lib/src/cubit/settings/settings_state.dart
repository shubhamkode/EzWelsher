part of 'settings_cubit.dart';

class Settings {
  final bool isDarkModeEnabled;

  const Settings({
    this.isDarkModeEnabled = false,
  });
}

typedef SettingsState = AsyncValue<Settings>;
