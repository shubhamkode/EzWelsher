import 'package:ez_debt/dependency_container.dart';
import 'package:ez_debt/src/cubit/settings/settings_cubit.dart';
import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/shared/routes/routes.dart';
import 'package:ez_debt/src/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependency();

  final prefs = await SharedPreferences.getInstance();

  final settingsCubit = SettingsCubit(prefs)..loadSettings();

  final blocProviders = [
    BlocProvider.value(
      value: settingsCubit,
    ),
    BlocProvider(
      create: (context) => s1<TenantCubit>(),
    ),
  ];

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 960),
      minTextAdapt: true,
      builder: (_, child) => MultiBlocProvider(
        providers: blocProviders,
        child: child!,
      ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return state.when(
          onData: (settings) {
            return MaterialApp.router(
              routerConfig: routes,
              debugShowCheckedModeBanner: false,
              theme: getLightTheme(context),
              darkTheme: getDarkTheme(context),
              themeMode:
                  settings.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            );
          },
        );
      },
      buildWhen: (previous, current) =>
          previous.data!.isDarkModeEnabled != current.data!.isDarkModeEnabled,
    );
  }
}
