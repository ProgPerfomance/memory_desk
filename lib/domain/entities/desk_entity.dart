class DeskEntity {
  final String? id;
  final String name;
  final String description;
  final String backgroundUrl;
  final String userId;

  DeskEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.description,
    required this.backgroundUrl,
  });

  factory DeskEntity.fromApi(Map map) {
    return DeskEntity(
      id: map['_id'],
      name: map['name'],
      userId: map['userId'],
      description: map['description'],
      backgroundUrl: map['backgroundUrl'],
    );
  }

  Map toApi() {
    return {
      "name": name,
      'description': description,
      "backgroundUrl": backgroundUrl,
      "userId": userId,
    };
  }
}
