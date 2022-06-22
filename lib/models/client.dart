import 'package:hive/hive.dart';
part 'client.g.dart';

@HiveType(typeId: 2)
class Client extends HiveObject {
  @HiveField(0)
  String name;

  Client({required this.name});
}
