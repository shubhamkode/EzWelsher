import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  late Future<Isar> _db;

  DatabaseService() {
    _db = openDatabase();
  }

  Future<Isar> openDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open([
        TenantSchema,
        EntriesSchema,
      ], directory: dir.path);
      return isar;
    }
    return Future.value(
      Isar.getInstance(),
    );
  }

  Future<List<Tenant>> readAllTenants() async {
    final Isar db = await _db;
    return await db.tenants.where().sortByName().findAll();
  }

  Future<void> createNewTenant({required Tenant tenant}) async {
    final db = await _db;
    db.writeTxnSync(() {
      db.tenants.putSync(tenant);
    });
  }

  Future<List<Entries>> readAllEntries() async {
    final Isar db = await _db;
    return await db.entries.where().findAll();
  }

  Future<List<Entries>> readAllEntriesByTenantId(int tenantId) async {
    final Isar db = await _db;
    return await db.entries
        .filter()
        .tenant((t) => t.idEqualTo(tenantId))
        .sortByDateDesc()
        .findAll();
  }

  Future<Entries> readEntryById(int entryId) async {
    final Isar db = await _db;
    return (await db.entries.filter().idEqualTo(entryId).findFirst())!;
  }

  Stream<List<Tenant>> listenToTenants() async* {
    final Isar db = await _db;
    yield* db.tenants.where().sortByName().findAll().asStream();
  }

  Future<void> createNewEntry(int tenantId, Entries newEntry) async {
    final Isar db = await _db;
    final tenant = (await db.tenants.filter().idEqualTo(tenantId).findFirst())!;
    tenant.entries.add(newEntry);
    createNewTenant(tenant: tenant);
  }

  Future<void> deleteEntry(int entryId) async {
    final Isar db = await _db;
    db.writeTxnSync(() {
      db.entries.deleteSync(entryId);
    });
  }

  Future<Tenant> getTenantById(int tenantId) async {
    final Isar db = await _db;
    return (await db.tenants.filter().idEqualTo(tenantId).findFirst())!;
  }

  updateEntry(Entries entry) async {
    final Isar db = await _db;
    db.writeTxnSync(() {
      db.entries.putSync(entry);
    });
  }

  Stream<List<Entries>> listenToEntries() async* {
    final Isar db = await _db;
    yield* db.entries.where().findAll().asStream();
  }

  Future<void> deleteDatabase() async {
    final Isar db = await _db;
    await db.writeTxn(() async {
      await db.clear();
    });
  }

  Future<void> deleteTenant(Id id) async {
    final Isar db = await _db;
    await db.writeTxn(() async {
      await db.tenants.delete(id);
    });
  }
}
