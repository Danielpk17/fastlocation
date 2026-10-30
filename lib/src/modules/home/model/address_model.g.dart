// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 0;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      cep: fields[0] as String,
      street: fields[1] as String,
      complement: fields[2] as String,
      neighborhood: fields[3] as String,
      city: fields[4] as String,
      state: fields[5] as String,
      consultedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cep)
      ..writeByte(1)
      ..write(obj.street)
      ..writeByte(2)
      ..write(obj.complement)
      ..writeByte(3)
      ..write(obj.neighborhood)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.consultedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
