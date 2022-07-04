// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentsAdapter extends TypeAdapter<Appointments> {
  @override
  final int typeId = 3;

  @override
  Appointments read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointments(
      worker: (fields[1] as HiveList).castHiveList(),
      client: (fields[2] as HiveList).castHiveList(),
      service: (fields[3] as HiveList).castHiveList(),
      initialDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      description: fields[6] as String?,
      situation: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Appointments obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.worker)
      ..writeByte(2)
      ..write(obj.client)
      ..writeByte(3)
      ..write(obj.service)
      ..writeByte(4)
      ..write(obj.initialDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.situation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
