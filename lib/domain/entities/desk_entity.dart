class DeskEntity {
  final String? id;
  final String name;
  final String description;
  final String backgroundUrl;
  final String userId;
  final String privacy;

  DeskEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.description,
    required this.backgroundUrl,
    required this.privacy,
  });

  factory DeskEntity.fromApi(Map map) {
    return DeskEntity(
      id: map['_id'],
      name: map['name'],
      userId: map['userId'],
      description: map['description'],
      backgroundUrl: map['backgroundUrl'],
      privacy: map['privacy'],
    );
  }

  Map toApi() {
    return {
      "name": name,
      'description': description,
      "backgroundUrl": backgroundUrl,
      "userId": userId,
      "privacy": privacy,
      "id": id,
    };
  }
}
