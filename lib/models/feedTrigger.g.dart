// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedTrigger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedTypeAdapter extends TypeAdapter<FeedType> {
  @override
  final int typeId = 1;

  @override
  FeedType read(BinaryReader reader) {
    switch (reader.readByte()) {
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, FeedType obj) {
    switch (obj) {
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FeedTriggerAdapter extends TypeAdapter<FeedTrigger> {
  @override
  final int typeId = 2;

  @override
  FeedTrigger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedTrigger(
      dateTime: fields[1] as DateTime,
      type: fields[0] as FeedType,
    );
  }

  @override
  void write(BinaryWriter writer, FeedTrigger obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedTriggerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
