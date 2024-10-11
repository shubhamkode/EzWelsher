import 'package:ez_debt/src/features/entries/models/entries.dart';
import 'package:isar/isar.dart';

part 'tenant.g.dart';

@collection
class Tenant {
  Id id = Isar.autoIncrement;
  String? name;
  String? contact;

  String? emailAddress;
  String? homeAddress;

  final entries = IsarLinks<Entries>();
}
