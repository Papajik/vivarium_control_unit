// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledTrigger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LedTriggerAdapter extends TypeAdapter<LedTrigger> {
  @override
  final int typeId = 3;

  @override
  LedTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LedTrigger(
      time: fields[0] as int,
      color: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LedTrigger obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
