// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class settingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 4;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      closeHour: fields[2] as int,
      closeMinute: fields[3] as int,
      openHour: fields[0] as int,
      openMinute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.openHour)
      ..writeByte(1)
      ..write(obj.openMinute)
      ..writeByte(2)
      ..write(obj.closeHour)
      ..writeByte(3)
      ..write(obj.closeMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is settingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
