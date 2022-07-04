import 'package:hive/hive.dart';
part 'service.g.dart';

@HiveType(typeId: 1)
class Service extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  Duration duration;

  Service({required this.name, required this.duration});
  @override
  String toString() {
    return name;
  }
}
