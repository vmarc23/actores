import 'dart:convert';

class ActorDesc {
  String biography;
  int id;
  ActorDesc({
    required this.id,
    required this.biography,
  });

  factory ActorDesc.fromJson(Map<String, dynamic> map) {
    return ActorDesc(
      id: map['id'] ?? '',
      biography: map['biography'] ?? '',
    );
  }
}
