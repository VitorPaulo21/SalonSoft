// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 6;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      bairro: fields[8] as String,
      cidade: fields[9] as String,
      cnpj: fields[2] as String,
      cpf: fields[3] as String,
      email: fields[4] as String,
      endereco: fields[6] as String,
      estado: fields[10] as String,
      logoPath: fields[1] as String,
      name: fields[0] as String,
      numero: fields[7] as String,
      phoneNumber: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.logoPath)
      ..writeByte(2)
      ..write(obj.cnpj)
      ..writeByte(3)
      ..write(obj.cpf)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.endereco)
      ..writeByte(7)
      ..write(obj.numero)
      ..writeByte(8)
      ..write(obj.bairro)
      ..writeByte(9)
      ..write(obj.cidade)
      ..writeByte(10)
      ..write(obj.estado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
