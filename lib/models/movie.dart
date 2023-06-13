import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String director;

  @HiveField(2)
  late String posterUrl;

 // Movie(this.name, this.director, this.posterUrl);
}
