// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_tv_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTVModelAdapter extends TypeAdapter<HiveTVModel> {
  @override
  final int typeId = 1;

  @override
  HiveTVModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTVModel(
      id: fields[0] as int,
      rating: fields[1] as double,
      name: fields[2] as String,
      backDrop: fields[3] as String,
      poster: fields[4] as String,
      overview: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTVModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.backDrop)
      ..writeByte(4)
      ..write(obj.poster)
      ..writeByte(5)
      ..write(obj.overview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTVModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
