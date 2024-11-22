import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;
  
  String? name;
  
  @Property(type: PropertyType.date) // ミリ秒単位のintとして格納
  DateTime? date;

  @Transient() // このプロパティはデータベースに保存されないので無視する。
  int? computedProperty;

  User({this.name});
}