import 'package:hive/hive.dart';
part 'client.g.dart';

@HiveType(typeId: 2)
class Client extends HiveObject {
  @HiveField(0)
  String name;
  String phoneNumber;

  Client({required this.name, this.phoneNumber = ""});

  @override
  String toString() {
    return name;
  }
}
