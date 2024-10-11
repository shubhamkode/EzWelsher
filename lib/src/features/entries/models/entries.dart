import 'package:ez_debt/src/features/tenant/models/tenant.dart';
import 'package:isar/isar.dart';

part 'entries.g.dart';

enum EntryType {
  recieved(0),
  paid(1);

  const EntryType(this.entryValue);
  final short entryValue;
}

@collection
class Entries {
  Id id = Isar.autoIncrement;
  DateTime? date;

  @Enumerated(EnumType.name)
  EntryType? type;

  String? purpose;
  double? amount;
  String? remark;

  @Backlink(to: "entries")
  final tenant = IsarLink<Tenant>();

  Entries copyWith(
      {DateTime? date,
      EntryType? type,
      String? purpose,
      double? amount,
      String? remark}) {
    return Entries()
      ..id = id
      ..date = date ?? this.date
      ..type = type ?? this.type
      ..purpose = purpose ?? this.purpose
      ..amount = amount ?? this.amount
      ..remark = remark ?? this.remark;
  }
}
