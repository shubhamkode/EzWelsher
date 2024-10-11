import 'package:ez_debt/src/cubit/tenant_cubit.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:get_it/get_it.dart';

GetIt s1 = GetIt.instance;

Future<void> initializeDependency() async {
  // Database:-
  s1.registerSingleton<DatabaseService>(DatabaseService());

  // Blocs:-
  s1.registerLazySingleton<TenantCubit>(
    () => TenantCubit(
      s1<DatabaseService>(),
    ),
  );
}
