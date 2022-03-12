import 'package:hive/hive.dart';
part 'hive_tv_model.g.dart';

@HiveType(typeId: 1)
class HiveTVModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double rating;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String backDrop;
  @HiveField(4)
  final String poster;
  @HiveField(5)
  final String overview;

  HiveTVModel({
    required this.id,
    required this.rating,
    required this.name,
    required this.backDrop,
    required this.poster,
    required this.overview,
  });
}
