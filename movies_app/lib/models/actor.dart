import 'dart:convert';
class Actor {
  String name;
  String profilepath;
  int id;
  double popularity;
  List<dynamic> peliculas;
  
  Actor({
    required this.profilepath,
    required this.name,
    required this.id,
    required this.peliculas,
    required this.popularity,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      name: map['name'] ?? '',
      profilepath: map['profile_path'] ?? '',
      id: map['id'] ?? '',
      peliculas: List<dynamic>.from(map['known_for']),
      popularity: map['popularity']?.toDouble() ?? 0.0,
    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));
}
