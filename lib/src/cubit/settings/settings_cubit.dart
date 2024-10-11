import 'package:ez_debt/src/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _preferences;

  SettingsCubit(this._preferences,{
    bool? isDarkModeEnabled,
  }) : super(
          SettingsLoaded(
            appSettings: Settings(
              isDarkModeEnabled: isDarkModeEnabled ?? false,
            ),
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
      SettingsLoaded(
        appSettings: settings,
      ),
    );
  }

  Future<void> toggleDarkMode() async {
    // emit(
    //   SettingsLoaded(
    //     appSettings: Settings(
    //       isDarkModeEnabled: !state.appSettings.isDarkModeEnabled,
    //     ),
    //   ),
    // );
    await _preferences.setBool(
      kDarkModekey,
      !state.appSettings.isDarkModeEnabled,
    );
    loadSettings();
  }

}
