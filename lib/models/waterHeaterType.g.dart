// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waterHeaterType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeaterTypeAdapter extends TypeAdapter<HeaterType> {
  @override
  final int typeId = 4;

  @override
  HeaterType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HeaterType.PID;
      case 1:
        return HeaterType.AUTO;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, HeaterType obj) {
    switch (obj) {
      case HeaterType.PID:
        writer.writeByte(0);
        break;
      case HeaterType.AUTO:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaterTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
