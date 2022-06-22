import 'package:hive/hive.dart';

part 'worker.g.dart';

@HiveType(typeId: 0)
class Worker extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String photoPath;
  Worker({required this.name, this.photoPath = ""});
}
