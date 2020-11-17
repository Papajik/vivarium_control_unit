// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outletTrigger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutletTriggerAdapter extends TypeAdapter<OutletTrigger> {
  @override
  final int typeId = 5;

  @override
  OutletTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutletTrigger(
      time: fields[0] as int,
      outletOn: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OutletTrigger obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.outletOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutletTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
