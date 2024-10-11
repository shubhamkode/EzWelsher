import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:meta/meta.dart';

part 'tenant_state.dart';

class TenantCubit extends Cubit<TenantCubitState> {
  final DatabaseService _databaseService;
  TenantCubit(this._databaseService) : super(TenantCubitLoading());

  Future<void> fetchTenant(int tenantId) async {
    emit(TenantCubitLoading());
    final tenant = await _databaseService.getTenantById(tenantId);
    emit(TenantCubitLoaded(tenant: tenant));
  }

  void refetchTenant() {
    if (state is TenantCubitLoaded) {
      fetchTenant((state as TenantCubitLoaded).tenant.id);
    }
  }

  Future<void> createNewEntry(Entries newEntry) async {
    await _databaseService.createNewEntry(
        (state as TenantCubitLoaded).tenant.id, newEntry);
    refetchTenant();
  }

  Future<void> deleteEntry(Id id) async {
    await _databaseService.deleteEntry(id);
    refetchTenant();
  }

  Future<void> updateEntry(Entries entry) async {
    await _databaseService.updateEntry(entry);
    refetchTenant();
  }

  Future<void> createNewTenant(Tenant tenant) async {
    await _databaseService.createNewTenant(tenant: tenant);
  }

  void reset() {
    emit(TenantCubitLoading());
  }
}
