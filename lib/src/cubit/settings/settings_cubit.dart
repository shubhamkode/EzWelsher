import 'package:ez_debt/src/shared/async_state.dart';
import 'package:ez_debt/src/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _preferences;

  SettingsCubit(this._preferences)
      : super(
          const AsyncValue(
            data: Settings(),
          ),
        );

  Future<Settings> getSettings() async {
    final bool? isDarkModeEnabled = _preferences.getBool(kDarkModekey);
    return Settings(
      isDarkModeEnabled: isDarkModeEnabled ?? false,
    );
  }

  Future<void> loadSettings() async {
    final settings = await getSettings();
    emit(
      AsyncValue(data: settings),
    );
  }

  Future<void> toggleDarkMode() async {
    await _preferences.setBool(
      kDarkModekey,
      !state.data!.isDarkModeEnabled,
    );
    loadSettings();
  }
}
