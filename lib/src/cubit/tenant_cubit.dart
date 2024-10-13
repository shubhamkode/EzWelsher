import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:ez_debt/src/shared/async_state.dart';
import 'package:ez_debt/src/shared/database_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tenant_state.dart';

class TenantCubit extends Cubit<TenantState> {
  final DatabaseService _databaseService;

  TenantCubit(
    this._databaseService,
  ) : super(const AsyncLoading());

  Future<void> fetchTenant(int tetantId) async {
    emit(const AsyncLoading());
    final tenant = await _databaseService.getTenantById(tetantId);
    emit(AsyncValue(data: tenant));
  }

  Future<void> invalidateSelf() async {
    if (state.data != null) {
      return fetchTenant(state.data!.id);
    }
    emit(
      const AsyncError(errMsg: "No Tenant Found"),
    );
  }

  Future<void> createNewEntry(Entries newEntry) async {
    await _databaseService.createNewEntry(state.data!.id, newEntry);
    invalidateSelf();
  }

  Future<void> deleteEntry(int entryId) async {
    await _databaseService.deleteEntry(entryId);
    invalidateSelf();
  }

  Future<void> updateEntry(Entries updatedEntry) async {
    await _databaseService.updateEntry(updatedEntry);
    invalidateSelf();
  }

  Future<void> reset() async {
    emit(const AsyncLoading());
  }
}
