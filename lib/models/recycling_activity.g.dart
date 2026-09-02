// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecyclingActivityAdapter extends TypeAdapter<RecyclingActivity> {
  @override
  final int typeId = 0;

  @override
  RecyclingActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecyclingActivity(
      item: fields[0] as String,
      quantity: (fields[1] as num).toInt(),
      points: (fields[2] as num).toInt(),
      dateTime: fields[3] as DateTime,
      photoPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecyclingActivity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.points)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.photoPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecyclingActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
