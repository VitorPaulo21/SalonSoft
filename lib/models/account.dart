import 'package:hive_flutter/hive_flutter.dart';
part 'account.g.dart';

@HiveType(typeId: 7)
class Account extends HiveObject {
  @HiveField(0)
  String email;
  @HiveField(1)
  String password;
  Account({required this.email, required this.password});
}
